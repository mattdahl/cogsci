if (Meteor.isClient) {
	var cards = [];
	var current_card = null;
	var current_card_index = 0;
	var timer = null;

	var present_next_card = function (event) {
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
			is_correct: is_set === current_card.data('is-match')
		};

		Responses.insert(response);

		current_card.toggleClass('current'); // Hide old current_card
		current_card = $(cards[current_card_index++]); // Advance to the new current_card
		current_card.toggleClass('current'); // Present the new current_card

		timer = new Date(); // Reset timer
	};

	$(document).ready(function () {
		cards = $('.card');
		cards = _.shuffle(cards);
		current_card = $(cards[current_card_index]);
		current_card.toggleClass('current');
		timer = new Date();

		$(document).on('keypress', present_next_card);
	});
}

if (Meteor.isServer) {
	Meteor.startup(function () {
	// code to run on server at startup
	});
}