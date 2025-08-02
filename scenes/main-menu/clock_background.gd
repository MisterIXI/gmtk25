extends Control

var background_color = Color(0.14901961, 0.2, 0.21960784, 0.0)
var clock_face_color = Color(0.8, 0.8, 0.8, 0.05)
var hand_color_hour = Color(0.9, 0.9, 0.9)
var hand_color_minute = Color(0.9, 0.9, 0.9)
var hand_color_second = Color(0.0, 0.74, 0.83)
var center_pin_color = Color(0.0, 0.74, 0.83)

# func _process(delta):
# 	queue_redraw()
	
func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), background_color)
	var center = size/ 2.0
	
	var radius= min(size.x,size.y)/2.5
	#draw_circle(center, radius, clock_face_color)
	
	var time = Time.get_time_dict_from_system()
	
	var houurs_angle = deg_to_rad((time.hour % 12 + time.minute / 60) * 30 - 90)
	var minute_angle = deg_to_rad((time.minute + time.second / 60) * 6 - 90)
	var second_angle =deg_to_rad(time.second * 6 - 90)

	draw_line(center, center + Vector2.from_angle(houurs_angle) * radius * 0.5, hand_color_hour, 6, true)
	draw_line(center, center + Vector2.from_angle(minute_angle) * radius * 0.8, hand_color_minute, 4, true)
	draw_line(center, center + Vector2.from_angle(second_angle) * radius * 0.9, hand_color_second, 2, true)

	draw_circle(center, 8.0, center_pin_color, true, -1, true)


func _on_timer_timeout():
	queue_redraw()
	
