'use strict';

function appendToOutput(li) {
  $('#output').append(li).animate({
    scrollTop: $('#output').prop('scrollHeight')
  }, {
    duration: 2000,
    queue: false
  });
}

function clearInput() {
  $('#choices').addClass('hidden');
  $('#number').addClass('hidden');
}

function appendData(data, done) {
  $('#choices').empty();

  var optIndex = data.search('<opt>');
  if (optIndex >=  0) {
    var optionsStr = data.substr(optIndex + 5);
    data = data.substr(0, optIndex);
    optionsStr = optionsStr.split(/(\d)\[(.+?)\]/g).filter(function(e) {
      return e.trim().length > 0;
    });
    var options = {};
    for (var i = 0; i < optionsStr.length; i += 2) {
      options[optionsStr[i]] = optionsStr[i + 1];
      var opt = $('<button>').attr('value', optionsStr[i]).text(optionsStr[i + 1]);
      $('#choices').append(opt);
    }
    $('#choices').removeClass('hidden');
  }

  var boolIndex = data.search('<bool>');
  if (boolIndex >= 0) {
    data = data.substr(0, boolIndex);
    var trueButton = $('<button>').attr('value', 'y').text('Yes');
    $('#choices').append(trueButton);
    var falseButton = $('<button>').attr('value', 'n').text('No');
    $('#choices').append(falseButton);
    $('#choices').removeClass('hidden');
  }

  if (boolIndex < 0 && optIndex < 0) {
    $('#number').removeClass('hidden').focus();
  }

  var li = $('<li>').text(data);
  appendToOutput(li);
  if (done && typeof done === 'function') {
    done();
  }
}

function sendValue(value, done) {
  clearInput();
  $.post('/input', { text: value }, function(data) {
    setTimeout(function() {
      appendData(data, done);
    }, 500);
  });
};

$('#debug').keyup(function(event) {
  if (event.keyCode === 13) {
    var val = $('#debug').val().trim();
    if (val.length > 0) {
      appendToOutput($('<li>').addClass('debug').text(val));
      sendValue(val, function(err) {
        if (!err) {
          $('#debug').val('');
        }
      });
    }
  }
});

$('#choices').on('click', 'button', function(event) {
  var currTarget = $(event.currentTarget);
  var val = currTarget.val();
  appendToOutput($('<li>').addClass('answer').text(currTarget.text()));
  sendValue(val);
});

$('#number').keyup(function(event) {
  var val = $('#number').val();
  $('#number').toggleClass('alert', parseInt(val) <= 0);
  if (event.keyCode === 13) {
    if (val.length > 0 && parseInt(val) > 0) {
      appendToOutput($('<li>').addClass('answer').text(val));
      sendValue(val, function(err) {
        if (!err) {
          $('#number').val('');
        }
      });
    }
  }
});
