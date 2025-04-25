# LightSwitch.gd
extends StaticBody3D

@export var is_on: bool = false

@onready var label: Label3D = $Label3D
@onready var mesh: MeshInstance3D = $MeshInstance3D

func _on_clicked():
	is_on = !is_on
	update_visual()

func update_visual():
	if is_on:
		#mesh.modulate = Color.GREEN
		label.text = "💡"
		send_post_request("on")
	else:
		#mesh.modulate = Color.RED
		label.text = "OFF"
		send_post_request("off")

func send_post_request(state):
	var http = HTTPRequest.new()
	add_child(http)  # It still needs to be in the scene tree to function

	# Connect signal to handle response
	http.request_completed.connect(_on_request_completed)

	#var url = "http://homeassistant.local:8123/api/services/switch/turn_on"
	var url = "http://192.168.0.249:8123/api/services/switch/turn_" + state
	var headers = ["Content-Type: application/json","Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJmNmQ0OTYyNWIzODU0OTQxODgzZjdiMTk5MDc4OGUzZSIsImlhdCI6MTc0NTUyMjIzOCwiZXhwIjoyMDYwODgyMjM4fQ.9JY_erD5c6ppmE7KkPIfp6avJCL8WWeQJSQcfOmpAcs"]
	var body = {"entity_id": "switch.lights"}
	var json_body = JSON.stringify(body)

	var result = http.request(url, headers, HTTPClient.METHOD_POST, json_body)
	if result != OK:
		print("Failed to send HTTP request. Error: ", result)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("Request finished with code: ", response_code)
	print("Response body: ", body.get_string_from_utf8())
