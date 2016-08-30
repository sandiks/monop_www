var user_name = null;
var chat_room = null;
var ws = null;

var strip_tags = function(data) {
	return data.replace(/<(?:.|\n)*?>/gm, '');
}

var clean_chat_room = function(data) {
	data = strip_tags(data);
	return data.replace(/[^\w]/g, '');
}

var clean_user_name = function(data) {
	data = strip_tags(data);
	return data.replace(/[^\w\ ]/g, '');
}


var init_chat_session = function() {

	chat_room = 'global';
	// open web socket
	ws = new WebSocket("ws://citipoly.club:8080/" + chat_room);

	ws.onerror = function(error) {};

	ws.onclose = function() {};

	ws.onopen = function() {
		init_send_message_form();
	};

	ws.onmessage = function(e) {

		data = JSON.parse(e.data);
		new_message = "<dt>" + data.user_name + "</dt><dd>" + data.message + "</dd>";
		$('#chat_messages').append(new_message);

	};

}

var init_send_message_form = function() {
	$('#btn-input').keydown(function(event) {
		if (event.keyCode == 13) {
			$('#btn-chat').click();
		}
	})


	// submit handler
	$('#btn-chat').click(function() {


		$message_field = $('#btn-input');
		message = $message_field.val();

		// clean data
		message = strip_tags(message);

		// update field vals
		$message_field.val('');

		user_name = $('#logged_uname').val();

		// validate
		if (message == '') {
			alert('Message is required.');
			return false;
		}

		data = {
			user_name: user_name,
			chat_room: 'global',
			message: message
		}

		// send message
		try {
			ws.send(JSON.stringify(data));
		} catch (err) {
			// debug
			//console.debug(err);
		}

		return false;
	});

};



$(document).ready(function() {

	init_chat_session();

});