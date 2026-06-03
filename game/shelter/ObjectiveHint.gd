extends RefCounted

func get_hint(snapshot: Dictionary) -> String:
	if not bool(snapshot.get("cushion_moved", false)):
		return "先把坐垫拖到干燥一点的地方。"
	if not bool(snapshot.get("milk_ready", false)):
		return "再点击牛奶碗，倒一点温牛奶。"
	if int(snapshot.get("pet_count", 0)) <= 0:
		return "最后轻轻摸摸小猫，让它知道这里安全。"
	return "它看起来安心多了。"
