'use strict';

function appendData(data, done) {
  $('#choices').addClass('hidden').empty();
  $('#number').addClass('hidden');

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
    $('#number').removeClass('hidden');
  }

  var li = $('<li>').text(data);
  $('#output').append(li);
  done();
}

function sendValue(value, done) {
  $.post('/input', { text: value }, function(data) {
    appendData(data, done);
  });
};

$('#debug').keyup(function(event) {
  if (event.keyCode === 13) {
    var val = $('#debug').val().trim();
    if (val.length > 0) {
      sendValue(val, function(err) {
        if (!err) {
          $('#debug').val('');
        }
      });
    }
  }
});

$('#choices').on('click', 'button', function(event) {
  var val = $(event.currentTarget).val();
  sendValue(val);
});

$('#number').keyup(function(event) {
  if (event.keyCode === 13) {
    var val = $('#number').val();
    if (val.length > 0 && parseInt(val) > 0) {
      sendValue(val, function(err) {
        if (!err) {
          $('#number').val('');
        }
      });
    } else {
      alert('Positive number pls.');
    }
  }
});
