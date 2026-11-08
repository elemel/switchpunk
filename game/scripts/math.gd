class_name Math


static func neg_8(a: int) -> int:
	return to_signed_8(-a)


static func add_8(a: int, b: int) -> int:
	return to_signed_8(a + b)


static func sub_8(a: int, b: int) -> int:
	return to_signed_8(a - b)


static func mul_8(a: int, b: int) -> int:
	return to_signed_8(a * b)


static func div_8(a: int, b: int) -> int:
	if b == 0:
		return 0

	return to_signed_8(floor_div(a, b))


static func mod_8(a: int, b: int) -> int:
	if b == 0:
		return 0

	return to_signed_8(posmod(a, b))


static func to_signed_8(value: int) -> int:
	return wrapi(value, -128, 127)


static func floor_div(a: int, b: int) -> int:
	return floori(float(a) / float(b))
