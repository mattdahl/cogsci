Meteor.methods({
	sendEmail: function (user_id) {
		// Let other method calls from the same client start running, without waiting for the email sending to complete.
		this.unblock();

		Email.send({
			to: 'matt.dahl.2013@gmail.com',
			from: 'matt.dahl.2013@gmail.com',
			subject: 'CogSci Data (user_id: ' + user_id + ')',
			text: JSON.stringify(Responses.find({user_id: user_id}).fetch())
		});
	}
});