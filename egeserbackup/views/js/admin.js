/**
 * Egeser Full Backup - back office UI.
 *
 * Drives the batch pipeline: every call to "processBatch" performs one bounded
 * unit of work on the server (scan a few directories, add one batch of files
 * to the ZIP, verify one part). The state lives on the server, so closing the
 * page only pauses the job; "Devam Et" resumes it.
 *
 * All dynamic values are inserted with jQuery.text() (no HTML injection).
 */
(function ($) {
  'use strict';

  $(function () {
    var $app = $('#egeser-backup-app');
    if (!$app.length) {
      return;
    }

    var cfg;
    try {
      cfg = JSON.parse($app.attr('data-config'));
    } catch (e) {
      return;
    }

    var T = cfg.texts || {};
    var MAX_RETRIES = 5;
    var RUNNING = ['scan', 'archive', 'verify'];
    var state = {
      job: null,
      running: false,
      retries: 0,
      timer: null,
      clockOffset: 0
    };

    function fmt(n) {
      var value = Number(n || 0);
      try {
        return value.toLocaleString('tr-TR');
      } catch (e) {
        return String(value);
      }
    }

    function pad(n) {
      return (n < 10 ? '0' : '') + n;
    }

    function formatElapsed(seconds) {
      seconds = Math.max(0, Math.floor(seconds));
      var h = Math.floor(seconds / 3600);
      var m = Math.floor((seconds % 3600) / 60);
      var s = seconds % 60;
      return (h > 0 ? h + ':' + pad(m) : pad(m)) + ':' + pad(s);
    }

    function isRunningStatus(status) {
      return $.inArray(status, RUNNING) !== -1;
    }

    function api(op, data) {
      return $.ajax({
        url: cfg.apiUrl + '&op=' + encodeURIComponent(op),
        type: 'POST',
        dataType: 'json',
        data: data || {},
        cache: false,
        timeout: 330000,
        headers: {'X-Egeser-Backup': '1'}
      });
    }

    function isValidResponse(res) {
      return res && typeof res === 'object' && typeof res.success === 'boolean';
    }

    function message(type, text) {
      $('#egb-message')
        .removeClass('alert-success alert-info alert-warning alert-danger')
        .addClass('alert-' + type)
        .text(text)
        .show();
    }

    function clearMessage() {
      $('#egb-message').hide().text('');
    }

    function stop() {
      if (state.timer) {
        clearTimeout(state.timer);
        state.timer = null;
      }
      state.running = false;
      setButtons();
    }

    function setButtons() {
      var job = state.job;
      var active = !!job;
      var ready = !!cfg.ready;
      var running = state.running;

      $('#egb-scan').toggle(!active).prop('disabled', !ready || running);
      $('#egb-start')
        .toggle(!active || job.status === 'ready')
        .prop('disabled', !ready || running);
      $('#egb-resume').toggle(active && !running && job.status !== 'ready' && job.status !== 'failed');
      $('#egb-cancel').toggle(active);
      $('#egb-progress-bar').toggleClass('active', running);
    }

    function renderIssues(issues) {
      var $body = $('#egb-issues').empty();
      if (!issues || !issues.length) {
        $('#egb-issues-wrap').hide();
        return;
      }
      var labels = {skipped: T.skipped, unreadable: T.unreadable, error: T.error};
      var classes = {skipped: 'label-default', unreadable: 'label-warning', error: 'label-danger'};
      for (var i = issues.length - 1; i >= 0; i--) {
        var issue = issues[i];
        $('<tr>')
          .append($('<td>').append($('<span class="label">').addClass(classes[issue.type] || 'label-danger').text(labels[issue.type] || issue.type)))
          .append($('<td>').append($('<code>').text(issue.path)))
          .append($('<td>').text(issue.message))
          .appendTo($body);
      }
      $('#egb-issues-wrap').show();
    }

    function render(job) {
      state.job = job || null;
      if (!job) {
        $('#egb-status').hide();
        $('#egb-issues-wrap').hide();
        $('#egb-idle').show();
        setButtons();
        return;
      }
      $('#egb-idle').hide();
      $('#egb-status').show();
      state.clockOffset = job.now * 1000 - Date.now();

      var label = job.status_label;
      if (job.status === 'verify') {
        label += ' - ' + T.verifyPart + ' ' + Math.min(job.verify_part, job.parts) + '/' + job.parts;
      }
      $('#egb-status-label').text(label);

      var $bar = $('#egb-progress-bar');
      $bar.removeClass('progress-bar-success progress-bar-danger progress-bar-info');
      if (job.percent === null) {
        $bar.addClass('progress-bar-info').css('width', '100%');
        $('#egb-progress-text').text(T.scanning + '... ' + fmt(job.dirs_scanned) + ' ' + T.dirsScanned);
        $('#egb-percent').text('-');
      } else {
        if (job.status === 'failed') {
          $bar.addClass('progress-bar-danger');
        } else if (job.status === 'verify') {
          $bar.addClass('progress-bar-success');
        }
        $bar.css('width', job.percent + '%');
        $('#egb-progress-text').text(job.percent + '%');
        $('#egb-percent').text(job.percent + '%');
      }

      $('#egb-total-files').text(fmt(job.total_entries));
      $('#egb-processed').text(fmt(job.processed));
      $('#egb-total-size').text(job.total_bytes_h);
      $('#egb-zip-size').text(job.zip_size_h + (job.parts > 1 ? ' (' + job.parts + ' ' + T.part.toLowerCase() + ')' : ''));
      $('#egb-success').text(fmt(job.success));
      $('#egb-skipped').text(fmt(job.skipped));
      $('#egb-unreadable').text(fmt(job.unreadable));
      $('#egb-errors').text(fmt(job.errors));
      $('#egb-current-file').text(job.status === 'scan' || !job.current_file ? '-' : job.current_file);

      var scanInfo = fmt(job.total_files) + ' ' + T.files + ', ' + fmt(job.total_dirs) + ' ' + T.emptyDirs
        + ' · ' + fmt(job.dirs_scanned) + ' ' + T.dirsScanned;
      if (job.status === 'scan') {
        scanInfo += ' · ' + fmt(job.pending_dirs) + ' ' + T.pendingDirs;
      }
      $('#egb-scan-info').text(scanInfo);
      $('#egb-excluded-info').text(' · ' + fmt(job.excluded) + ' ' + T.excluded);

      var $space = $('#egb-space');
      if (job.space && job.space.message) {
        var cls = {ok: 'alert-info', warn: 'alert-warning', unknown: 'alert-warning', block: 'alert-danger'};
        $space
          .removeClass('alert-info alert-warning alert-danger')
          .addClass(cls[job.space.level] || 'alert-info')
          .text(job.space.message)
          .show();
      } else {
        $space.hide();
      }

      if (job.status === 'failed' && job.error) {
        message('danger', job.error);
      }
      renderIssues(job.issues);
      tick();
      setButtons();
    }

    function tick() {
      if (!state.job || !isRunningStatus(state.job.status)) {
        return;
      }
      var now = (Date.now() + state.clockOffset) / 1000;
      $('#egb-elapsed').text(formatElapsed(now - state.job.started_at));
    }

    function showCompleted(meta) {
      var $body = $('#egb-completed-body').empty();
      $('<p>').text(fmt(meta.files) + ' ' + T.files + ' · ' + meta.size_h + ' · ' + meta.status_label).appendTo($body);
      $.each(meta.parts || [], function (i, part) {
        var $p = $('<div class="egb-part">');
        $('<strong>').text(part.file).appendTo($p);
        $p.append(document.createTextNode(' (' + part.size_h + ', ' + fmt(part.entries) + ' ' + T.entries + ') '));
        $('<a class="btn btn-default btn-sm">')
          .attr('href', part.url)
          .append($('<i class="icon-download">'))
          .append(document.createTextNode(' ' + T.download))
          .appendTo($p);
        $('<div class="egb-hash">').text('SHA-256: ').append($('<code>').text(part.sha256)).appendTo($p);
        $p.appendTo($body);
      });
      if (meta.report_url) {
        $('<p>').append(
          $('<a class="btn btn-default btn-sm">').attr('href', meta.report_url).text(T.report)
        ).appendTo($body);
      }
      $('#egb-completed').show();
      message('success', T.completed);
    }

    function xhrFailure(xhr, textStatus) {
      var res = xhr && xhr.responseJSON;
      if (isValidResponse(res)) {
        // A clean JSON error (permission, token...): retrying will not help.
        stop();
        message('danger', res.message);
        return;
      }
      // HTML instead of JSON (expired session -> login page, invalid token page,
      // PHP fatal error): retried a few times, then reported as such.
      retryOrStop(textStatus === 'parsererror' ? T.invalidResponse : T.networkError);
    }

    function retryOrStop(text) {
      if (state.retries < MAX_RETRIES) {
        state.retries++;
        var delay = Math.min(30000, 2000 * Math.pow(2, state.retries - 1));
        message('warning', T.retrying + ' (' + state.retries + '/' + MAX_RETRIES + ')...');
        state.running = true;
        setButtons();
        state.timer = setTimeout(step, delay);
        return;
      }
      state.retries = 0;
      stop();
      message('danger', text);
    }

    function loop() {
      state.running = true;
      setButtons();
      state.timer = setTimeout(step, 50);
    }

    function step() {
      state.timer = null;
      api('processBatch').done(function (res) {
        if (!isValidResponse(res)) {
          retryOrStop(T.invalidResponse);
          return;
        }
        if (!res.success) {
          stop();
          if (res.data && res.data.job) {
            render(res.data.job);
          }
          message('danger', res.message);
          return;
        }
        if (state.retries > 0) {
          state.retries = 0;
          clearMessage();
        }
        var d = res.data || {};
        if (d.cancelled) {
          stop();
          render(null);
          message('info', res.message);
          return;
        }
        if (d.completed) {
          stop();
          render(null);
          showCompleted(d.completed);
          return;
        }
        if (d.busy) {
          if (d.job) {
            render(d.job);
          }
          message('info', T.busy);
          state.timer = setTimeout(step, 2000);
          return;
        }
        if (!d.job) {
          stop();
          render(null);
          return;
        }
        render(d.job);
        if (isRunningStatus(d.job.status)) {
          state.timer = setTimeout(step, 50);
          return;
        }
        stop();
        if (d.job.status === 'ready') {
          if (d.job.autostart) {
            startArchive(false);
          } else {
            message('success', T.scanDone);
          }
        }
      }).fail(xhrFailure);
    }

    function start(withBackup) {
      clearMessage();
      $('#egb-completed').hide();
      state.running = true;
      setButtons();
      api(withBackup ? 'startBackup' : 'scan').done(function (res) {
        if (!isValidResponse(res)) {
          stop();
          message('danger', T.invalidResponse);
          return;
        }
        if (res.data && res.data.job) {
          render(res.data.job);
        }
        if (!res.success) {
          stop();
          message('danger', res.message);
          return;
        }
        if (res.data && res.data.need_confirm) {
          confirmSpace(res.message);
          return;
        }
        loop();
      }).fail(function (xhr) {
        stop();
        var res = xhr && xhr.responseJSON;
        message('danger', isValidResponse(res) ? res.message : T.networkError);
      });
    }

    function confirmSpace(text) {
      stop();
      if (window.confirm(T.confirmSpace + '\n\n' + text + '\n\n' + T.confirmContinue)) {
        startArchive(true);
      }
    }

    function startArchive(confirmed) {
      clearMessage();
      state.running = true;
      setButtons();
      api('startBackup', {confirm: confirmed ? 1 : 0}).done(function (res) {
        if (!isValidResponse(res)) {
          stop();
          message('danger', T.invalidResponse);
          return;
        }
        if (res.data && res.data.job) {
          render(res.data.job);
        }
        if (!res.success) {
          stop();
          message('danger', res.message);
          return;
        }
        if (res.data && res.data.need_confirm) {
          confirmSpace(res.message);
          return;
        }
        loop();
      }).fail(function (xhr) {
        stop();
        var res = xhr && xhr.responseJSON;
        message('danger', isValidResponse(res) ? res.message : T.networkError);
      });
    }

    function pollUntilCancelled(attempt) {
      api('status').done(function (res) {
        if (isValidResponse(res) && res.success && !res.data.job) {
          render(null);
          message('info', T.cancelled);
          return;
        }
        if (attempt < 60) {
          setTimeout(function () {
            pollUntilCancelled(attempt + 1);
          }, 2000);
        }
      });
    }

    $('#egb-scan').on('click', function () {
      start(false);
    });

    $('#egb-start').on('click', function () {
      if (state.job && state.job.status === 'ready') {
        startArchive(false);
      } else {
        start(true);
      }
    });

    $('#egb-resume').on('click', function () {
      clearMessage();
      state.retries = 0;
      loop();
    });

    $('#egb-cancel').on('click', function () {
      if (!window.confirm(T.confirmCancel)) {
        return;
      }
      api('cancel').done(function (res) {
        if (!isValidResponse(res)) {
          message('danger', T.invalidResponse);
          return;
        }
        if (!res.success) {
          message('danger', res.message);
          return;
        }
        if (res.data.cancelled) {
          stop();
          render(null);
          message('info', res.message);
        } else {
          message('warning', res.message);
          if (!state.running) {
            pollUntilCancelled(0);
          }
        }
      }).fail(function () {
        message('danger', T.networkError);
      });
    });

    $app.on('click', '.egb-delete', function () {
      var id = $(this).attr('data-backup');
      if (!window.confirm(T.confirmDelete + '\n\n' + id)) {
        return;
      }
      var $row = $(this).closest('tr');
      api('deleteBackup', {backup: id}).done(function (res) {
        if (!isValidResponse(res)) {
          message('danger', T.invalidResponse);
          return;
        }
        if (res.success) {
          $row.remove();
          message('success', res.message);
        } else {
          message('danger', res.message);
        }
      }).fail(function (xhr) {
        var res = xhr && xhr.responseJSON;
        message('danger', isValidResponse(res) ? res.message : T.networkError);
      });
    });

    $('#egb-cleanup').on('click', function () {
      if (!window.confirm(String(T.confirmCleanup).replace('%d', cfg.retentionDays))) {
        return;
      }
      api('cleanup').done(function (res) {
        if (!isValidResponse(res)) {
          message('danger', T.invalidResponse);
          return;
        }
        message(res.success ? 'success' : 'danger', res.message);
        if (res.success && res.data.deleted && res.data.deleted.length) {
          setTimeout(function () {
            window.location.reload();
          }, 1200);
        }
      }).fail(function () {
        message('danger', T.networkError);
      });
    });

    $('#egb-reload').on('click', function (e) {
      e.preventDefault();
      window.location.reload();
    });

    $(window).on('beforeunload', function (e) {
      if (state.running) {
        (e.originalEvent || e).returnValue = T.leaveWarning;
        return T.leaveWarning;
      }
      return undefined;
    });

    setInterval(tick, 1000);

    render(cfg.job);
    if (cfg.job) {
      if (isRunningStatus(cfg.job.status)) {
        message('warning', T.resumeHint);
      } else if (cfg.job.status === 'ready') {
        message('info', T.scanDone);
      }
    }
  });
})(jQuery);
