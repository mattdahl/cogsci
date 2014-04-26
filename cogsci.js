if (Meteor.isClient) {
	var cards = [];
	var current_card = null;
	var current_card_index = 0;
	var current_audio = null;
	var current_state = 0;
	var timer = null;

	var present_next_card = function (event) {
		if (current_card_index === 12 && current_state === 0) {
			current_card.toggleClass('current');
			current_card_index = 0;
			cards = _.shuffle($('.card'));
			current_card = $(cards[current_card_index]);
			current_card.toggleClass('current');

			current_audio.pause();
			current_audio = $('#bad_chord')[0];
			current_audio.play();

			current_state = 1;
		}
		else if (current_card_index === 12 && current_state === 1) {
			current_audio.pause();
			$('#instructions').html('Thanks! All finished.');
		}

		var is_set;
		if (event.keyCode == 121) {
			is_set = true;
		}
		else if (event.keyCode == 110) {
			is_set = false;
		}
		else {
			return false;
		}

		var response = {
			card_id: current_card.attr('src'),
			response_time: (new Date()) - timer,
			response: is_set,
			is_correct: is_set === current_card.data('is-set')
		};

		Responses.insert(response);

		debugger;
		current_card.toggleClass('current'); // Hide old current_card
		current_card = $(cards[current_card_index++]); // Advance to the new current_card
		current_card.toggleClass('current'); // Present the new current_card

		timer = new Date(); // Reset timer
	};

	var load_experiment = function (event) {
		$('#welcome').hide();
		cards = _.shuffle($('.card'));
		current_card = $(cards[current_card_index]);
		current_card.toggleClass('current');
		timer = new Date();
		current_audio = $('#good_chord')[0];
		current_audio.play();
		$('#experiment').show();

		$(document).off('keypress', load_experiment);
		$(document).on('keypress', present_next_card);
	};

	$(document).ready(function () {
		$(document).on('keypress', load_experiment);
	});
}

if (Meteor.isServer) {
	Meteor.startup(function () {
	// code to run on server at startup
	});
}