# When It Rains Steam Demo Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the first playable Steam Demo slice for `When It Rains / 当雨落下时`: two kitten visits, low-pressure care interactions, leaf placement, codex reveal, save/reset, and a Windows-ready local demo foundation.

**Architecture:** Create the actual Godot project at `E:\GodotProject\when-it-rains` and keep the GitHub repo as the source of truth. Build the demo as small scenes and focused scripts: demo flow, weather, care interactions, kitten state, keepsake placement, codex, save/settings. Use placeholder art first so the complete emotional loop is playable before asset polish.

**Tech Stack:** Godot 4.6.2, GDScript, Godot built-in Resource files, JSON save file, Git/GitHub, Godot MCP for editor/run actions when available.

---

## File Structure

Create or modify these paths under `E:\GodotProject\when-it-rains`:

- `.gitignore`: Ignore Godot imports, temporary files, logs, build exports, and local brainstorm files.
- `project.godot`: Godot project configuration.
- `docs/superpowers/specs/2026-05-30-when-it-rains-demo-design.md`: Existing approved design spec.
- `docs/superpowers/plans/2026-05-30-when-it-rains-demo-implementation.md`: This plan.
- `game/main/Main.tscn`: Main entry scene.
- `game/main/Main.gd`: Loads save/settings and routes between menu, shelter, and ending.
- `game/main/MainMenu.tscn`: Main menu UI.
- `game/main/MainMenu.gd`: Emits start/continue/settings/reset/quit actions.
- `game/shelter/ShelterScene.tscn`: Main playable shelter scene.
- `game/shelter/ShelterScene.gd`: Wires controllers together and advances demo stages.
- `game/shelter/WeatherController.gd`: Authored rain/rain-stop sequence and weather signals.
- `game/shelter/CareController.gd`: Cushion, milk, petting, and dryness state.
- `game/cat/CatActor.tscn`: Kitten scene with placeholder visuals and clickable area.
- `game/cat/CatActor.gd`: Kitten behavior facade.
- `game/cat/CatStateMachine.gd`: Kitten state machine.
- `game/keepsakes/KeepsakeCorner.tscn`: Fixed-slot leaf placement.
- `game/keepsakes/KeepsakeCorner.gd`: Drag/drop fixed-slot placement logic.
- `game/ui/CodexPanel.tscn`: Animal + keepsake codex panel.
- `game/ui/CodexPanel.gd`: Renders unlocked and locked codex entries.
- `game/ui/SettingsPanel.tscn`: Volume/fullscreen/reset controls.
- `game/ui/SettingsPanel.gd`: Applies settings.
- `game/services/SaveService.gd`: Autoload for JSON save data.
- `game/services/CodexService.gd`: Autoload for codex state.
- `game/resources/AnimalProfile.gd`: Resource type for animals.
- `game/resources/KeepsakeProfile.gd`: Resource type for keepsakes.
- `game/resources/DemoStageConfig.gd`: Resource type for authored stage timing.
- `game/resources/profiles/kitten.tres`: Kitten profile.
- `game/resources/keepsakes/leaf.tres`: Leaf profile.
- `game/tests/TestRunner.tscn`: Minimal in-project test runner scene.
- `game/tests/TestRunner.gd`: Runs pure GDScript assertions for services/state machines.
- `game/tests/test_cat_state_machine.gd`: Tests kitten state transitions.
- `game/tests/test_save_service.gd`: Tests save serialization defaults and reset.
- `game/tests/test_codex_service.gd`: Tests codex unlocks.
- `game/tests/test_care_controller.gd`: Tests care state and comfort scoring.

## Implementation Notes

- Use `E:\GodotProject\when-it-rains` as the real project directory.
- Keep branch `master` tracking `origin/master` unless the user asks to create a feature branch.
- First implementation milestone should use colored rectangles, labels, and generated simple placeholder assets only.
- Do not add Steamworks SDK in this plan.
- Do not implement freeform decoration, shop, resource economy, or additional full animal loops.
- Verification commands can use Godot MCP `run_project` when shell `godot` is unavailable.

---

### Task 1: Move Source Of Truth To `E:\GodotProject\when-it-rains`

**Files:**
- Create/clone directory: `E:\GodotProject\when-it-rains`
- Modify: `E:\GodotProject\when-it-rains\.gitignore`
- Preserve remote: `https://github.com/zhangguixia/when-it-rains.git`

- [ ] **Step 1: Clone the GitHub repo into the Godot project directory**

Run:

```powershell
cd "E:\GodotProject"
git clone https://github.com/zhangguixia/when-it-rains.git when-it-rains
```

Expected: `E:\GodotProject\when-it-rains` exists and contains `.git`, `.gitignore`, and `docs`.

- [ ] **Step 2: Verify the remote and branch**

Run:

```powershell
cd "E:\GodotProject\when-it-rains"
git remote -v
git branch --show-current
git status --short
```

Expected:

```text
origin  https://github.com/zhangguixia/when-it-rains.git (fetch)
origin  https://github.com/zhangguixia/when-it-rains.git (push)
master
```

`git status --short` should print nothing.

- [ ] **Step 3: Expand `.gitignore` for Godot**

Replace `E:\GodotProject\when-it-rains\.gitignore` with:

```gitignore
.superpowers/
.godot/
.import/
*.translation
export_presets.cfg
exports/
builds/
*.tmp
*.log
user://
```

- [ ] **Step 4: Commit the project-location prep**

Run:

```powershell
git add .gitignore
git commit -m "chore: prepare Godot project ignore rules"
git push
```

Expected: commit succeeds and pushes to `origin/master`.

---

### Task 2: Create Godot Project Skeleton

**Files:**
- Create: `E:\GodotProject\when-it-rains\project.godot`
- Create: `E:\GodotProject\when-it-rains\game\main\Main.tscn`
- Create: `E:\GodotProject\when-it-rains\game\main\Main.gd`
- Create: `E:\GodotProject\when-it-rains\game\main\MainMenu.tscn`
- Create: `E:\GodotProject\when-it-rains\game\main\MainMenu.gd`

- [ ] **Step 1: Create Godot project config**

Create `project.godot`:

```ini
; Engine configuration file.
; It's best edited using the editor UI and not directly,
; since the parameters that go here are not all obvious.

config_version=5

[application]

config/name="When It Rains"
run/main_scene="res://game/main/Main.tscn"
config/features=PackedStringArray("4.6", "Forward Plus")

[display]

window/size/viewport_width=1920
window/size/viewport_height=1080
window/stretch/mode="canvas_items"
window/stretch/aspect="expand"

[rendering]

renderer/rendering_method="forward_plus"
```

- [ ] **Step 2: Create main scene**

Create `game/main/Main.tscn`:

```ini
[gd_scene load_steps=2 format=3 uid="uid://whenitrainsmain"]

[ext_resource type="Script" path="res://game/main/Main.gd" id="1"]

[node name="Main" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
script = ExtResource("1")

[node name="Content" type="Control" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
```

- [ ] **Step 3: Create main script**

Create `game/main/Main.gd`:

```gdscript
extends Control

const MAIN_MENU_SCENE := preload("res://game/main/MainMenu.tscn")
const SHELTER_SCENE := "res://game/shelter/ShelterScene.tscn"

@onready var content: Control = %Content

func _ready() -> void:
	_show_main_menu()

func _show_main_menu() -> void:
	_clear_content()
	var menu := MAIN_MENU_SCENE.instantiate()
	menu.start_requested.connect(_start_demo)
	menu.continue_requested.connect(_continue_demo)
	menu.reset_requested.connect(_reset_progress)
	menu.quit_requested.connect(_quit_game)
	content.add_child(menu)

func _start_demo() -> void:
	SaveService.start_new_demo()
	get_tree().change_scene_to_file(SHELTER_SCENE)

func _continue_demo() -> void:
	get_tree().change_scene_to_file(SHELTER_SCENE)

func _reset_progress() -> void:
	SaveService.reset_progress()
	_show_main_menu()

func _quit_game() -> void:
	get_tree().quit()

func _clear_content() -> void:
	for child in content.get_children():
		child.queue_free()
```

- [ ] **Step 4: Create menu scene**

Create `game/main/MainMenu.tscn`:

```ini
[gd_scene load_steps=2 format=3 uid="uid://whenitrainsmainmenu"]

[ext_resource type="Script" path="res://game/main/MainMenu.gd" id="1"]

[node name="MainMenu" type="CenterContainer"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
script = ExtResource("1")

[node name="Panel" type="PanelContainer" parent="."]
layout_mode = 2

[node name="VBox" type="VBoxContainer" parent="Panel"]
layout_mode = 2
theme_override_constants/separation = 18

[node name="Title" type="Label" parent="Panel/VBox"]
layout_mode = 2
text = "When It Rains"
horizontal_alignment = 1

[node name="Subtitle" type="Label" parent="Panel/VBox"]
layout_mode = 2
text = "当雨落下时"
horizontal_alignment = 1

[node name="StartButton" type="Button" parent="Panel/VBox"]
layout_mode = 2
text = "开始 Demo"

[node name="ContinueButton" type="Button" parent="Panel/VBox"]
layout_mode = 2
text = "继续"

[node name="ResetButton" type="Button" parent="Panel/VBox"]
layout_mode = 2
text = "重置进度"

[node name="QuitButton" type="Button" parent="Panel/VBox"]
layout_mode = 2
text = "退出"
```

- [ ] **Step 5: Create menu script**

Create `game/main/MainMenu.gd`:

```gdscript
extends CenterContainer

signal start_requested
signal continue_requested
signal reset_requested
signal quit_requested

@onready var start_button: Button = %StartButton
@onready var continue_button: Button = %ContinueButton
@onready var reset_button: Button = %ResetButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	start_button.pressed.connect(func() -> void: start_requested.emit())
	continue_button.pressed.connect(func() -> void: continue_requested.emit())
	reset_button.pressed.connect(func() -> void: reset_requested.emit())
	quit_button.pressed.connect(func() -> void: quit_requested.emit())
	continue_button.disabled = not SaveService.has_started_demo()
```

- [ ] **Step 6: Validate the project metadata**

Use Godot MCP:

```text
get_project_info(projectPath="E:\\GodotProject\\when-it-rains")
```

Expected: project name is `When It Rains`. The main menu is not run until Task 3 adds the service autoloads required by `MainMenu.gd`.

- [ ] **Step 7: Commit**

Run:

```powershell
git add project.godot game/main
git commit -m "feat: add Godot project shell and main menu"
git push
```

---

### Task 3: Add Services And Test Harness

**Files:**
- Modify: `project.godot`
- Create: `game/services/SaveService.gd`
- Create: `game/services/CodexService.gd`
- Create: `game/tests/TestRunner.tscn`
- Create: `game/tests/TestRunner.gd`
- Create: `game/tests/test_save_service.gd`
- Create: `game/tests/test_codex_service.gd`

- [ ] **Step 1: Write save service tests**

Create `game/tests/test_save_service.gd`:

```gdscript
extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	SaveService.reset_progress()
	assert_equal.call(SaveService.get_stage(), "not_started", "fresh stage")
	assert_true.call(not SaveService.has_started_demo(), "fresh save has not started")

	SaveService.start_new_demo()
	assert_equal.call(SaveService.get_stage(), "first_rain", "new demo starts at first rain")
	assert_true.call(SaveService.has_started_demo(), "started demo flag")

	SaveService.set_stage("leaf_placement")
	SaveService.set_leaf_slot(2)
	assert_equal.call(SaveService.get_stage(), "leaf_placement", "stage saves in memory")
	assert_equal.call(SaveService.get_leaf_slot(), 2, "leaf slot saves in memory")

	SaveService.reset_progress()
	assert_equal.call(SaveService.get_stage(), "not_started", "reset stage")
	assert_equal.call(SaveService.get_leaf_slot(), -1, "reset leaf slot")
```

- [ ] **Step 2: Write codex service tests**

Create `game/tests/test_codex_service.gd`:

```gdscript
extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	CodexService.reset_codex()
	assert_true.call(not CodexService.is_animal_unlocked("kitten"), "kitten starts locked")
	assert_true.call(not CodexService.is_keepsake_unlocked("leaf"), "leaf starts locked")

	CodexService.unlock_animal("kitten")
	CodexService.unlock_keepsake("leaf")
	assert_true.call(CodexService.is_animal_unlocked("kitten"), "kitten unlocks")
	assert_true.call(CodexService.is_keepsake_unlocked("leaf"), "leaf unlocks")

	var animals := CodexService.get_animal_entries()
	assert_equal.call(animals.size(), 4, "demo shows four animal entries")
	assert_equal.call(animals[0]["id"], "kitten", "first animal is kitten")
	assert_true.call(animals[1]["locked"], "dog is locked preview")
```

- [ ] **Step 3: Create test runner**

Create `game/tests/TestRunner.gd`:

```gdscript
extends Node

var failures: Array[String] = []

func _ready() -> void:
	_run_script("res://game/tests/test_save_service.gd")
	_run_script("res://game/tests/test_codex_service.gd")
	if failures.is_empty():
		print("TESTS PASSED")
		get_tree().quit(0)
	else:
		for failure in failures:
			push_error(failure)
		get_tree().quit(1)

func _run_script(path: String) -> void:
	var script := load(path)
	var suite = script.new()
	suite.run(_assert_true, _assert_equal)

func _assert_true(value: bool, label: String) -> void:
	if not value:
		failures.append("Expected true: %s" % label)

func _assert_equal(actual, expected, label: String) -> void:
	if actual != expected:
		failures.append("%s expected <%s> got <%s>" % [label, expected, actual])
```

Create `game/tests/TestRunner.tscn`:

```ini
[gd_scene load_steps=2 format=3 uid="uid://whenitrainstestrunner"]

[ext_resource type="Script" path="res://game/tests/TestRunner.gd" id="1"]

[node name="TestRunner" type="Node"]
script = ExtResource("1")
```

- [ ] **Step 4: Add service autoloads to `project.godot`**

Add this section to `project.godot` after `[application]`:

```ini
[autoload]

SaveService="*res://game/services/SaveService.gd"
CodexService="*res://game/services/CodexService.gd"
```

- [ ] **Step 5: Run tests and verify they fail**

Use Godot MCP:

```text
run_project(projectPath="E:\\GodotProject\\when-it-rains", scene="res://game/tests/TestRunner.tscn")
```

Expected: failure because `SaveService.gd` and `CodexService.gd` do not exist yet.

- [ ] **Step 6: Implement SaveService**

Create `game/services/SaveService.gd`:

```gdscript
extends Node

const SAVE_PATH := "user://when_it_rains_demo_save.json"

var data := _default_data()

func _ready() -> void:
	load_progress()

func _default_data() -> Dictionary:
	return {
		"stage": "not_started",
		"kitten_visits": 0,
		"leaf_collected": false,
		"leaf_slot": -1,
		"settings": {
			"master_volume": 1.0,
			"ambience_volume": 1.0,
			"music_volume": 0.8,
			"fullscreen": false
		}
	}

func has_started_demo() -> bool:
	return data["stage"] != "not_started"

func start_new_demo() -> void:
	data = _default_data()
	data["stage"] = "first_rain"
	save_progress()

func reset_progress() -> void:
	data = _default_data()
	save_progress()

func get_stage() -> String:
	return String(data["stage"])

func set_stage(stage: String) -> void:
	data["stage"] = stage
	save_progress()

func get_leaf_slot() -> int:
	return int(data["leaf_slot"])

func set_leaf_slot(slot_index: int) -> void:
	data["leaf_slot"] = slot_index
	save_progress()

func set_leaf_collected(value: bool) -> void:
	data["leaf_collected"] = value
	save_progress()

func is_leaf_collected() -> bool:
	return bool(data["leaf_collected"])

func set_kitten_visits(count: int) -> void:
	data["kitten_visits"] = count
	save_progress()

func get_kitten_visits() -> int:
	return int(data["kitten_visits"])

func get_settings() -> Dictionary:
	return data["settings"].duplicate(true)

func set_setting(key: String, value) -> void:
	data["settings"][key] = value
	save_progress()

func save_progress() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Could not write save file: %s" % SAVE_PATH)
		return
	file.store_string(JSON.stringify(data))

func load_progress() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		data = _default_data()
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		data = _default_data()
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		data = _default_data()
		return
	data = _default_data()
	for key in parsed.keys():
		data[key] = parsed[key]
```

- [ ] **Step 7: Implement CodexService**

Create `game/services/CodexService.gd`:

```gdscript
extends Node

var unlocked_animals: Dictionary = {}
var unlocked_keepsakes: Dictionary = {}

const ANIMAL_ENTRIES := [
	{"id": "kitten", "name": "小猫", "hint": "它记得这个屋檐。"},
	{"id": "dog", "name": "小狗", "hint": "远处传来一声叫声。"},
	{"id": "bird", "name": "小鸟", "hint": "有羽毛落在窗边。"},
	{"id": "hedgehog", "name": "小刺猬", "hint": "它还在找避雨的路。"}
]

const KEEPSAKE_ENTRIES := [
	{"id": "leaf", "name": "落叶", "text": "它留下的落叶，边缘还带着雨水。"},
	{"id": "glass_marble", "name": "玻璃珠", "text": "还未获得。"},
	{"id": "feather", "name": "羽毛", "text": "还未获得。"},
	{"id": "acorn", "name": "橡果", "text": "还未获得。"}
]

func reset_codex() -> void:
	unlocked_animals.clear()
	unlocked_keepsakes.clear()

func unlock_animal(id: String) -> void:
	unlocked_animals[id] = true

func unlock_keepsake(id: String) -> void:
	unlocked_keepsakes[id] = true

func is_animal_unlocked(id: String) -> bool:
	return unlocked_animals.get(id, false)

func is_keepsake_unlocked(id: String) -> bool:
	return unlocked_keepsakes.get(id, false)

func get_animal_entries() -> Array:
	var result: Array = []
	for entry in ANIMAL_ENTRIES:
		var item := entry.duplicate(true)
		item["locked"] = not is_animal_unlocked(String(item["id"]))
		result.append(item)
	return result

func get_keepsake_entries() -> Array:
	var result: Array = []
	for entry in KEEPSAKE_ENTRIES:
		var item := entry.duplicate(true)
		item["locked"] = not is_keepsake_unlocked(String(item["id"]))
		result.append(item)
	return result
```

- [ ] **Step 8: Run tests and verify they pass**

Use Godot MCP:

```text
run_project(projectPath="E:\\GodotProject\\when-it-rains", scene="res://game/tests/TestRunner.tscn")
```

Expected output includes:

```text
TESTS PASSED
```

- [ ] **Step 9: Run the main menu**

Use Godot MCP:

```text
run_project(projectPath="E:\\GodotProject\\when-it-rains")
```

Expected: main menu opens with title, subtitle, start, continue, reset, and quit buttons. Continue is disabled on a fresh save.

- [ ] **Step 10: Commit**

Run:

```powershell
git add game/services game/tests project.godot
git commit -m "feat: add save and codex services"
git push
```

---

### Task 4: Add Resource Types And Demo Data

**Files:**
- Create: `game/resources/AnimalProfile.gd`
- Create: `game/resources/KeepsakeProfile.gd`
- Create: `game/resources/DemoStageConfig.gd`
- Create: `game/resources/profiles/kitten.tres`
- Create: `game/resources/keepsakes/leaf.tres`

- [ ] **Step 1: Create AnimalProfile resource script**

Create `game/resources/AnimalProfile.gd`:

```gdscript
class_name AnimalProfile
extends Resource

@export var id: String
@export var display_name: String
@export_multiline var description: String
@export var keepsake_id: String
@export var unlocked_in_demo: bool = false
```

- [ ] **Step 2: Create KeepsakeProfile resource script**

Create `game/resources/KeepsakeProfile.gd`:

```gdscript
class_name KeepsakeProfile
extends Resource

@export var id: String
@export var display_name: String
@export_multiline var memory_text: String
@export var unlocked_in_demo: bool = false
```

- [ ] **Step 3: Create DemoStageConfig resource script**

Create `game/resources/DemoStageConfig.gd`:

```gdscript
class_name DemoStageConfig
extends Resource

@export var stage_id: String
@export var rain_active: bool = true
@export var duration_seconds: float = 8.0
@export_multiline var stage_caption: String
```

- [ ] **Step 4: Create kitten profile resource**

Create `game/resources/profiles/kitten.tres`:

```ini
[gd_resource type="Resource" script_class="AnimalProfile" load_steps=2 format=3 uid="uid://kittenprofile"]

[ext_resource type="Script" path="res://game/resources/AnimalProfile.gd" id="1"]

[resource]
script = ExtResource("1")
id = "kitten"
display_name = "小猫"
description = "第一次来时，它在雨里犹豫了很久。第二次来时，它认得这个屋檐。"
keepsake_id = "leaf"
unlocked_in_demo = true
```

- [ ] **Step 5: Create leaf keepsake resource**

Create `game/resources/keepsakes/leaf.tres`:

```ini
[gd_resource type="Resource" script_class="KeepsakeProfile" load_steps=2 format=3 uid="uid://leafkeepsake"]

[ext_resource type="Script" path="res://game/resources/KeepsakeProfile.gd" id="1"]

[resource]
script = ExtResource("1")
id = "leaf"
display_name = "落叶"
memory_text = "它留下的落叶，边缘还带着雨水。"
unlocked_in_demo = true
```

- [ ] **Step 6: Validate resources load**

Use Godot MCP:

```text
run_project(projectPath="E:\\GodotProject\\when-it-rains", scene="res://game/tests/TestRunner.tscn")
```

Expected: tests still pass and no resource parse errors appear in debug output.

- [ ] **Step 7: Commit**

Run:

```powershell
git add game/resources
git commit -m "feat: add demo resource profiles"
git push
```

---

### Task 5: Implement Cat State Machine And Care Logic

**Files:**
- Create: `game/cat/CatStateMachine.gd`
- Create: `game/tests/test_cat_state_machine.gd`
- Create: `game/shelter/CareController.gd`
- Create: `game/tests/test_care_controller.gd`
- Modify: `game/tests/TestRunner.gd`

- [ ] **Step 1: Write cat state machine test**

Create `game/tests/test_cat_state_machine.gd`:

```gdscript
extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	var machine := load("res://game/cat/CatStateMachine.gd").new()
	assert_equal.call(machine.state, "Hesitating", "initial cat state")

	machine.apply_care({"cushion_comfort": 0.8, "milk_ready": false, "pet_count": 0, "visit": 1})
	assert_equal.call(machine.state, "Approaching", "comfortable cushion invites approach")

	machine.apply_care({"cushion_comfort": 0.8, "milk_ready": true, "pet_count": 0, "visit": 1})
	assert_equal.call(machine.state, "Drinking", "milk leads to drinking")

	machine.apply_care({"cushion_comfort": 0.8, "milk_ready": true, "pet_count": 2, "visit": 1})
	assert_equal.call(machine.state, "Purring", "petting after milk leads to purring")

	machine.start_leaving()
	assert_equal.call(machine.state, "Leaving", "leaving state")

	machine.start_returning()
	assert_equal.call(machine.state, "Returning", "returning state")
```

- [ ] **Step 2: Write care controller test**

Create `game/tests/test_care_controller.gd`:

```gdscript
extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	var care := load("res://game/shelter/CareController.gd").new()
	assert_equal.call(care.cushion_area, "center", "default cushion area")
	assert_equal.call(care.get_cushion_comfort(), 0.65, "default comfort")

	care.move_cushion("dry_left")
	assert_equal.call(care.cushion_area, "dry_left", "cushion moves")
	assert_equal.call(care.get_cushion_comfort(), 0.95, "dry area comfort")

	care.pour_milk()
	assert_true.call(care.milk_ready, "milk ready")

	care.pet_cat()
	care.pet_cat()
	assert_equal.call(care.pet_count, 2, "pet count")

	var snapshot := care.get_care_snapshot(2)
	assert_equal.call(snapshot["visit"], 2, "snapshot visit")
	assert_true.call(snapshot["milk_ready"], "snapshot milk")
```

- [ ] **Step 3: Register new tests**

Modify `game/tests/TestRunner.gd` so `_ready()` is:

```gdscript
func _ready() -> void:
	_run_script("res://game/tests/test_save_service.gd")
	_run_script("res://game/tests/test_codex_service.gd")
	_run_script("res://game/tests/test_cat_state_machine.gd")
	_run_script("res://game/tests/test_care_controller.gd")
	if failures.is_empty():
		print("TESTS PASSED")
		get_tree().quit(0)
	else:
		for failure in failures:
			push_error(failure)
		get_tree().quit(1)
```

- [ ] **Step 4: Run tests and verify they fail**

Use Godot MCP:

```text
run_project(projectPath="E:\\GodotProject\\when-it-rains", scene="res://game/tests/TestRunner.tscn")
```

Expected: failure because `CatStateMachine.gd` and `CareController.gd` do not exist yet.

- [ ] **Step 5: Implement cat state machine**

Create `game/cat/CatStateMachine.gd`:

```gdscript
extends RefCounted

signal state_changed(new_state: String)

var state := "Hesitating"

func apply_care(snapshot: Dictionary) -> void:
	var comfort := float(snapshot.get("cushion_comfort", 0.0))
	var milk_ready := bool(snapshot.get("milk_ready", false))
	var pet_count := int(snapshot.get("pet_count", 0))

	if pet_count >= 2 and milk_ready:
		_set_state("Purring")
	elif milk_ready:
		_set_state("Drinking")
	elif comfort >= 0.7:
		_set_state("Approaching")
	elif comfort >= 0.5:
		_set_state("Resting")
	else:
		_set_state("Hesitating")

func start_leaving() -> void:
	_set_state("Leaving")

func start_returning() -> void:
	_set_state("Returning")

func _set_state(next_state: String) -> void:
	if state == next_state:
		return
	state = next_state
	state_changed.emit(state)
```

- [ ] **Step 6: Implement care controller logic**

Create `game/shelter/CareController.gd`:

```gdscript
extends Node

signal care_changed(snapshot: Dictionary)

const AREA_DRYNESS := {
	"dry_left": 0.95,
	"center": 0.65,
	"wet_right": 0.35
}

var cushion_area := "center"
var milk_ready := false
var pet_count := 0

func move_cushion(area_id: String) -> void:
	if not AREA_DRYNESS.has(area_id):
		push_warning("Unknown cushion area: %s" % area_id)
		return
	cushion_area = area_id
	care_changed.emit(get_care_snapshot(1))

func pour_milk() -> void:
	milk_ready = true
	care_changed.emit(get_care_snapshot(1))

func pet_cat() -> void:
	pet_count += 1
	care_changed.emit(get_care_snapshot(1))

func get_cushion_comfort() -> float:
	return float(AREA_DRYNESS[cushion_area])

func get_care_snapshot(visit: int) -> Dictionary:
	return {
		"cushion_area": cushion_area,
		"cushion_comfort": get_cushion_comfort(),
		"milk_ready": milk_ready,
		"pet_count": pet_count,
		"visit": visit
	}

func reset_for_next_visit() -> void:
	milk_ready = false
	pet_count = 0
```

- [ ] **Step 7: Run tests and verify they pass**

Use Godot MCP:

```text
run_project(projectPath="E:\\GodotProject\\when-it-rains", scene="res://game/tests/TestRunner.tscn")
```

Expected output includes:

```text
TESTS PASSED
```

- [ ] **Step 8: Commit**

Run:

```powershell
git add game/cat game/shelter/CareController.gd game/tests
git commit -m "feat: add kitten care state logic"
git push
```

---

### Task 6: Build Playable Shelter Loop With Placeholders

**Files:**
- Create: `game/shelter/ShelterScene.tscn`
- Create: `game/shelter/ShelterScene.gd`
- Create: `game/shelter/WeatherController.gd`
- Create: `game/cat/CatActor.tscn`
- Create: `game/cat/CatActor.gd`

- [ ] **Step 1: Create WeatherController**

Create `game/shelter/WeatherController.gd`:

```gdscript
extends Node

signal rain_started(visit: int)
signal rain_stopped(visit: int)

var visit := 1
var raining := false

func start_first_rain() -> void:
	visit = 1
	raining = true
	rain_started.emit(visit)

func stop_rain() -> void:
	raining = false
	rain_stopped.emit(visit)

func start_second_rain() -> void:
	visit = 2
	raining = true
	rain_started.emit(visit)
```

- [ ] **Step 2: Create CatActor scene**

Create `game/cat/CatActor.tscn`:

```ini
[gd_scene load_steps=2 format=3 uid="uid://catactor"]

[ext_resource type="Script" path="res://game/cat/CatActor.gd" id="1"]

[sub_resource type="RectangleShape2D" id="RectangleShape2D_1"]
size = Vector2(180, 110)

[node name="CatActor" type="Area2D"]
script = ExtResource("1")

[node name="Body" type="ColorRect" parent="."]
offset_left = -80.0
offset_top = -48.0
offset_right = 80.0
offset_bottom = 48.0
color = Color(0.45, 0.45, 0.48, 1)

[node name="Label" type="Label" parent="."]
offset_left = -90.0
offset_top = -82.0
offset_right = 90.0
offset_bottom = -52.0
text = "湿漉漉的小猫"
horizontal_alignment = 1

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
position = Vector2(0, 0)
shape = SubResource("RectangleShape2D_1")
```

- [ ] **Step 3: Create CatActor script**

Create `game/cat/CatActor.gd`:

```gdscript
extends Area2D

signal petted

@onready var label: Label = %Label
@onready var body: ColorRect = %Body

var state_machine := preload("res://game/cat/CatStateMachine.gd").new()

func _ready() -> void:
	input_event.connect(_on_input_event)
	state_machine.state_changed.connect(_on_state_changed)
	_on_state_changed(state_machine.state)

func apply_care(snapshot: Dictionary) -> void:
	state_machine.apply_care(snapshot)

func start_leaving() -> void:
	state_machine.start_leaving()

func start_returning() -> void:
	state_machine.start_returning()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		petted.emit()

func _on_state_changed(new_state: String) -> void:
	label.text = _label_for_state(new_state)
	body.color = _color_for_state(new_state)

func _label_for_state(new_state: String) -> String:
	match new_state:
		"Hesitating": return "小猫还在犹豫"
		"Approaching": return "小猫靠近了"
		"Resting": return "小猫坐下了"
		"Drinking": return "小猫在喝牛奶"
		"Purring": return "小猫安心地呼噜"
		"Leaving": return "雨停了，它回头看了一眼"
		"Returning": return "它又回来了"
		_: return "小猫"

func _color_for_state(new_state: String) -> Color:
	match new_state:
		"Hesitating": return Color(0.38, 0.42, 0.48, 1)
		"Approaching": return Color(0.50, 0.50, 0.52, 1)
		"Drinking": return Color(0.62, 0.58, 0.50, 1)
		"Purring": return Color(0.78, 0.64, 0.48, 1)
		"Leaving": return Color(0.70, 0.70, 0.68, 1)
		"Returning": return Color(0.90, 0.72, 0.50, 1)
		_: return Color(0.45, 0.45, 0.48, 1)
```

- [ ] **Step 4: Create ShelterScene**

Create `game/shelter/ShelterScene.tscn` with a placeholder layout:

```ini
[gd_scene load_steps=5 format=3 uid="uid://shelterscene"]

[ext_resource type="Script" path="res://game/shelter/ShelterScene.gd" id="1"]
[ext_resource type="Script" path="res://game/shelter/WeatherController.gd" id="2"]
[ext_resource type="Script" path="res://game/shelter/CareController.gd" id="3"]
[ext_resource type="PackedScene" path="res://game/cat/CatActor.tscn" id="4"]

[node name="ShelterScene" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
script = ExtResource("1")

[node name="Background" type="ColorRect" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
color = Color(0.12, 0.14, 0.18, 1)

[node name="RainLabel" type="Label" parent="."]
layout_mode = 0
offset_left = 48.0
offset_top = 36.0
offset_right = 620.0
offset_bottom = 80.0
text = "雨正在落下"

[node name="PromptLabel" type="Label" parent="."]
layout_mode = 0
offset_left = 48.0
offset_top = 92.0
offset_right = 1000.0
offset_bottom = 140.0
text = "拖动坐垫、点击牛奶碗、轻轻摸摸小猫。"

[node name="CushionButton" type="Button" parent="."]
layout_mode = 0
offset_left = 330.0
offset_top = 760.0
offset_right = 530.0
offset_bottom = 840.0
text = "坐垫：移动到干燥处"

[node name="MilkButton" type="Button" parent="."]
layout_mode = 0
offset_left = 600.0
offset_top = 760.0
offset_right = 800.0
offset_bottom = 840.0
text = "倒牛奶"

[node name="AdvanceButton" type="Button" parent="."]
layout_mode = 0
offset_left = 870.0
offset_top = 760.0
offset_right = 1070.0
offset_bottom = 840.0
text = "推进天气"

[node name="WeatherController" type="Node" parent="."]
script = ExtResource("2")

[node name="CareController" type="Node" parent="."]
script = ExtResource("3")

[node name="CatActor" parent="." instance=ExtResource("4")]
position = Vector2(960, 600)
```

- [ ] **Step 5: Create ShelterScene script**

Create `game/shelter/ShelterScene.gd`:

```gdscript
extends Control

@onready var rain_label: Label = %RainLabel
@onready var prompt_label: Label = %PromptLabel
@onready var cushion_button: Button = %CushionButton
@onready var milk_button: Button = %MilkButton
@onready var advance_button: Button = %AdvanceButton
@onready var weather: Node = %WeatherController
@onready var care: Node = %CareController
@onready var cat: Area2D = %CatActor

var visit := 1
var stage := "first_rain"

func _ready() -> void:
	cushion_button.pressed.connect(_move_cushion)
	milk_button.pressed.connect(_pour_milk)
	advance_button.pressed.connect(_advance_weather)
	cat.petted.connect(_pet_cat)
	care.care_changed.connect(_on_care_changed)
	weather.rain_started.connect(_on_rain_started)
	weather.rain_stopped.connect(_on_rain_stopped)
	weather.start_first_rain()
	SaveService.set_stage("first_rain")

func _move_cushion() -> void:
	care.move_cushion("dry_left")
	prompt_label.text = "坐垫挪到了更干燥的地方。"

func _pour_milk() -> void:
	care.pour_milk()
	prompt_label.text = "牛奶倒好了，小猫闻到了。"

func _pet_cat() -> void:
	care.pet_cat()
	prompt_label.text = "你轻轻摸了摸小猫。"

func _on_care_changed(snapshot: Dictionary) -> void:
	snapshot["visit"] = visit
	cat.apply_care(snapshot)

func _advance_weather() -> void:
	match stage:
		"first_rain":
			stage = "first_goodbye"
			weather.stop_rain()
			cat.start_leaving()
			SaveService.set_stage("first_goodbye")
		"first_goodbye":
			stage = "second_rain"
			visit = 2
			care.reset_for_next_visit()
			weather.start_second_rain()
			cat.start_returning()
			SaveService.set_stage("second_rain")
		"second_rain":
			stage = "leaf_placement"
			SaveService.set_stage("leaf_placement")
			get_tree().change_scene_to_file("res://game/keepsakes/KeepsakeCorner.tscn")

func _on_rain_started(rain_visit: int) -> void:
	rain_label.text = "第 %d 场雨正在落下" % rain_visit

func _on_rain_stopped(_rain_visit: int) -> void:
	rain_label.text = "雨停了。"
	prompt_label.text = "它离开前回头看了一眼，留下了一片落叶。"
	SaveService.set_leaf_collected(true)
	CodexService.unlock_animal("kitten")
	CodexService.unlock_keepsake("leaf")
```

- [ ] **Step 6: Run manual loop verification**

Use Godot MCP:

```text
run_project(projectPath="E:\\GodotProject\\when-it-rains")
```

Expected:

- Start Demo opens shelter.
- Cushion button changes prompt and kitten state.
- Milk button changes prompt and kitten state.
- Clicking kitten changes prompt and kitten state.
- Advance weather once shows rain stopped and goodbye.
- Advance weather again shows second rain and returning state.
- Stop the manual check after the second advance. The third advance loads the keepsake scene, which is created in Task 7.

- [ ] **Step 7: Commit**

Run:

```powershell
git add game/shelter game/cat
git commit -m "feat: add playable shelter care loop"
git push
```

---

### Task 7: Add Leaf Placement And Codex Reveal

**Files:**
- Create: `game/keepsakes/KeepsakeCorner.tscn`
- Create: `game/keepsakes/KeepsakeCorner.gd`
- Create: `game/ui/CodexPanel.tscn`
- Create: `game/ui/CodexPanel.gd`

- [ ] **Step 1: Create keepsake corner scene**

Create `game/keepsakes/KeepsakeCorner.tscn`:

```ini
[gd_scene load_steps=2 format=3 uid="uid://keepsakecorner"]

[ext_resource type="Script" path="res://game/keepsakes/KeepsakeCorner.gd" id="1"]

[node name="KeepsakeCorner" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
script = ExtResource("1")

[node name="Title" type="Label" parent="."]
offset_left = 80.0
offset_top = 60.0
offset_right = 1000.0
offset_bottom = 110.0
text = "把落叶放进第一个收容角落"

[node name="SlotButtons" type="HBoxContainer" parent="."]
offset_left = 260.0
offset_top = 360.0
offset_right = 1660.0
offset_bottom = 560.0
theme_override_constants/separation = 60

[node name="Slot0" type="Button" parent="SlotButtons"]
custom_minimum_size = Vector2(320, 180)
text = "窗边"

[node name="Slot1" type="Button" parent="SlotButtons"]
custom_minimum_size = Vector2(320, 180)
text = "坐垫旁"

[node name="Slot2" type="Button" parent="SlotButtons"]
custom_minimum_size = Vector2(320, 180)
text = "木箱上"
```

- [ ] **Step 2: Create keepsake corner script**

Create `game/keepsakes/KeepsakeCorner.gd`:

```gdscript
extends Control

const CODEX_SCENE := preload("res://game/ui/CodexPanel.tscn")

@onready var slot_0: Button = %Slot0
@onready var slot_1: Button = %Slot1
@onready var slot_2: Button = %Slot2

func _ready() -> void:
	slot_0.pressed.connect(func() -> void: _choose_slot(0))
	slot_1.pressed.connect(func() -> void: _choose_slot(1))
	slot_2.pressed.connect(func() -> void: _choose_slot(2))

func _choose_slot(index: int) -> void:
	SaveService.set_leaf_slot(index)
	SaveService.set_stage("codex_reveal")
	CodexService.unlock_animal("kitten")
	CodexService.unlock_keepsake("leaf")
	_show_codex()

func _show_codex() -> void:
	for child in get_children():
		child.queue_free()
	var codex := CODEX_SCENE.instantiate()
	add_child(codex)
```

- [ ] **Step 3: Create codex panel scene**

Create `game/ui/CodexPanel.tscn`:

```ini
[gd_scene load_steps=2 format=3 uid="uid://codexpanel"]

[ext_resource type="Script" path="res://game/ui/CodexPanel.gd" id="1"]

[node name="CodexPanel" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
script = ExtResource("1")

[node name="Title" type="Label" parent="."]
offset_left = 80.0
offset_top = 60.0
offset_right = 1100.0
offset_bottom = 110.0
text = "图鉴"

[node name="AnimalList" type="VBoxContainer" parent="."]
offset_left = 120.0
offset_top = 160.0
offset_right = 860.0
offset_bottom = 780.0

[node name="KeepsakeList" type="VBoxContainer" parent="."]
offset_left = 980.0
offset_top = 160.0
offset_right = 1720.0
offset_bottom = 780.0

[node name="EndingText" type="Label" parent="."]
offset_left = 120.0
offset_top = 850.0
offset_right = 1720.0
offset_bottom = 920.0
text = "远处传来一声轻轻的狗叫。雨还会再来的。"
horizontal_alignment = 1
```

- [ ] **Step 4: Create codex panel script**

Create `game/ui/CodexPanel.gd`:

```gdscript
extends Control

@onready var animal_list: VBoxContainer = %AnimalList
@onready var keepsake_list: VBoxContainer = %KeepsakeList

func _ready() -> void:
	_render_animals()
	_render_keepsakes()
	SaveService.set_stage("demo_complete")

func _render_animals() -> void:
	animal_list.add_child(_make_header("动物"))
	for entry in CodexService.get_animal_entries():
		animal_list.add_child(_make_entry(entry["name"], entry["hint"], entry["locked"]))

func _render_keepsakes() -> void:
	keepsake_list.add_child(_make_header("纪念品"))
	for entry in CodexService.get_keepsake_entries():
		keepsake_list.add_child(_make_entry(entry["name"], entry["text"], entry["locked"]))

func _make_header(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return label

func _make_entry(title: String, body: String, locked: bool) -> PanelContainer:
	var panel := PanelContainer.new()
	var box := VBoxContainer.new()
	var title_label := Label.new()
	var body_label := Label.new()
	title_label.text = "???" if locked else title
	body_label.text = body if not locked else "还没有遇见。"
	box.add_child(title_label)
	box.add_child(body_label)
	panel.add_child(box)
	return panel
```

- [ ] **Step 5: Run full placeholder demo**

Use Godot MCP:

```text
run_project(projectPath="E:\\GodotProject\\when-it-rains")
```

Expected:

- Start Demo reaches shelter.
- Advance through first rain, second rain, leaf placement.
- Choosing a slot opens codex.
- Codex shows kitten and leaf unlocked, future entries locked.
- Ending text teases dog.

- [ ] **Step 6: Commit**

Run:

```powershell
git add game/keepsakes game/ui
git commit -m "feat: add leaf placement and codex reveal"
git push
```

---

### Task 8: Add Settings Panel And Reset Flow

**Files:**
- Create: `game/ui/SettingsPanel.tscn`
- Create: `game/ui/SettingsPanel.gd`
- Modify: `game/main/MainMenu.tscn`
- Modify: `game/main/MainMenu.gd`
- Modify: `game/main/Main.gd`

- [ ] **Step 1: Add settings signal to menu script**

Modify `game/main/MainMenu.gd`:

```gdscript
extends CenterContainer

signal start_requested
signal continue_requested
signal settings_requested
signal reset_requested
signal quit_requested

@onready var start_button: Button = %StartButton
@onready var continue_button: Button = %ContinueButton
@onready var settings_button: Button = %SettingsButton
@onready var reset_button: Button = %ResetButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	start_button.pressed.connect(func() -> void: start_requested.emit())
	continue_button.pressed.connect(func() -> void: continue_requested.emit())
	settings_button.pressed.connect(func() -> void: settings_requested.emit())
	reset_button.pressed.connect(func() -> void: reset_requested.emit())
	quit_button.pressed.connect(func() -> void: quit_requested.emit())
	continue_button.disabled = not SaveService.has_started_demo()
```

- [ ] **Step 2: Add settings button to menu scene**

Insert this node in `game/main/MainMenu.tscn` between `ContinueButton` and `ResetButton`:

```ini
[node name="SettingsButton" type="Button" parent="Panel/VBox"]
layout_mode = 2
text = "设置"
```

- [ ] **Step 3: Create settings panel scene**

Create `game/ui/SettingsPanel.tscn`:

```ini
[gd_scene load_steps=2 format=3 uid="uid://settingspanel"]

[ext_resource type="Script" path="res://game/ui/SettingsPanel.gd" id="1"]

[node name="SettingsPanel" type="CenterContainer"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
script = ExtResource("1")

[node name="Panel" type="PanelContainer" parent="."]
layout_mode = 2

[node name="VBox" type="VBoxContainer" parent="Panel"]
layout_mode = 2

[node name="MasterSlider" type="HSlider" parent="Panel/VBox"]
layout_mode = 2
min_value = 0.0
max_value = 1.0
step = 0.05
value = 1.0

[node name="RainSlider" type="HSlider" parent="Panel/VBox"]
layout_mode = 2
min_value = 0.0
max_value = 1.0
step = 0.05
value = 1.0

[node name="MusicSlider" type="HSlider" parent="Panel/VBox"]
layout_mode = 2
min_value = 0.0
max_value = 1.0
step = 0.05
value = 0.8

[node name="FullscreenCheck" type="CheckBox" parent="Panel/VBox"]
layout_mode = 2
text = "全屏"

[node name="BackButton" type="Button" parent="Panel/VBox"]
layout_mode = 2
text = "返回"
```

- [ ] **Step 4: Create settings panel script**

Create `game/ui/SettingsPanel.gd`:

```gdscript
extends CenterContainer

signal back_requested

@onready var master_slider: HSlider = %MasterSlider
@onready var rain_slider: HSlider = %RainSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var fullscreen_check: CheckBox = %FullscreenCheck
@onready var back_button: Button = %BackButton

func _ready() -> void:
	var settings := SaveService.get_settings()
	master_slider.value = float(settings["master_volume"])
	rain_slider.value = float(settings["ambience_volume"])
	music_slider.value = float(settings["music_volume"])
	fullscreen_check.button_pressed = bool(settings["fullscreen"])

	master_slider.value_changed.connect(func(value: float) -> void: SaveService.set_setting("master_volume", value))
	rain_slider.value_changed.connect(func(value: float) -> void: SaveService.set_setting("ambience_volume", value))
	music_slider.value_changed.connect(func(value: float) -> void: SaveService.set_setting("music_volume", value))
	fullscreen_check.toggled.connect(_set_fullscreen)
	back_button.pressed.connect(func() -> void: back_requested.emit())

func _set_fullscreen(enabled: bool) -> void:
	SaveService.set_setting("fullscreen", enabled)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if enabled else DisplayServer.WINDOW_MODE_WINDOWED)
```

- [ ] **Step 5: Wire settings panel in Main**

Modify `game/main/Main.gd`:

```gdscript
extends Control

const MAIN_MENU_SCENE := preload("res://game/main/MainMenu.tscn")
const SETTINGS_SCENE := preload("res://game/ui/SettingsPanel.tscn")
const SHELTER_SCENE := "res://game/shelter/ShelterScene.tscn"

@onready var content: Control = %Content

func _ready() -> void:
	_show_main_menu()

func _show_main_menu() -> void:
	_clear_content()
	var menu := MAIN_MENU_SCENE.instantiate()
	menu.start_requested.connect(_start_demo)
	menu.continue_requested.connect(_continue_demo)
	menu.settings_requested.connect(_show_settings)
	menu.reset_requested.connect(_reset_progress)
	menu.quit_requested.connect(_quit_game)
	content.add_child(menu)

func _show_settings() -> void:
	_clear_content()
	var settings := SETTINGS_SCENE.instantiate()
	settings.back_requested.connect(_show_main_menu)
	content.add_child(settings)

func _start_demo() -> void:
	SaveService.start_new_demo()
	get_tree().change_scene_to_file(SHELTER_SCENE)

func _continue_demo() -> void:
	get_tree().change_scene_to_file(SHELTER_SCENE)

func _reset_progress() -> void:
	SaveService.reset_progress()
	CodexService.reset_codex()
	_show_main_menu()

func _quit_game() -> void:
	get_tree().quit()

func _clear_content() -> void:
	for child in content.get_children():
		child.queue_free()
```

- [ ] **Step 6: Verify settings manually**

Use Godot MCP:

```text
run_project(projectPath="E:\\GodotProject\\when-it-rains")
```

Expected:

- Settings opens from main menu.
- Sliders can move.
- Fullscreen checkbox toggles display mode.
- Back returns to menu.
- Reset progress disables Continue again after returning to menu.

- [ ] **Step 7: Commit**

Run:

```powershell
git add game/main game/ui/SettingsPanel.tscn game/ui/SettingsPanel.gd
git commit -m "feat: add demo settings and reset flow"
git push
```

---

### Task 9: Add Placeholder Atmosphere And Final Verification

**Files:**
- Modify: `game/shelter/ShelterScene.tscn`
- Modify: `game/shelter/ShelterScene.gd`
- Modify: `docs/superpowers/specs/2026-05-30-when-it-rains-demo-design.md` only if implementation reality needs a documented correction.

- [ ] **Step 1: Add rain and lighting placeholder nodes**

Add these nodes to `game/shelter/ShelterScene.tscn` under `Background`:

```ini
[node name="WarmLight" type="ColorRect" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
color = Color(1.0, 0.75, 0.35, 0.12)

[node name="RainLines" type="Label" parent="."]
layout_mode = 0
offset_left = 1320.0
offset_top = 80.0
offset_right = 1820.0
offset_bottom = 760.0
text = "／／／／／／／／／／\n／／／／／／／／／／\n／／／／／／／／／／\n／／／／／／／／／／"
modulate = Color(0.6, 0.7, 0.9, 0.6)
```

- [ ] **Step 2: Add stage captions**

In `game/shelter/ShelterScene.gd`, update `_on_rain_started`:

```gdscript
func _on_rain_started(rain_visit: int) -> void:
	rain_label.text = "第 %d 场雨正在落下" % rain_visit
	if rain_visit == 1:
		prompt_label.text = "屋檐外很冷。它还不确定能不能进来。"
	else:
		prompt_label.text = "它又来了。这一次，它没有犹豫那么久。"
```

- [ ] **Step 3: Run tests**

Use Godot MCP:

```text
run_project(projectPath="E:\\GodotProject\\when-it-rains", scene="res://game/tests/TestRunner.tscn")
```

Expected output includes:

```text
TESTS PASSED
```

- [ ] **Step 4: Run full demo manually**

Use Godot MCP:

```text
run_project(projectPath="E:\\GodotProject\\when-it-rains")
```

Expected manual checklist:

- Main menu appears.
- Start Demo opens rainy shelter.
- Player can move cushion, pour milk, and pet kitten.
- First advance shows rain stopped and leaf acquired.
- Second advance shows kitten returning.
- Third advance opens leaf placement.
- Choosing a slot opens codex.
- Codex shows kitten and leaf unlocked and future entries locked.
- Settings and reset work after relaunch.

- [ ] **Step 5: Commit final placeholder demo milestone**

Run:

```powershell
git add game docs
git commit -m "feat: complete placeholder Steam demo loop"
git push
```

---

## Self-Review

Spec coverage:

- Two-visit kitten arc: Tasks 5-7.
- Low-pressure care interactions: Tasks 5-6.
- Leaf keepsake placement: Task 7.
- Animal + keepsake codex: Tasks 3 and 7.
- Locked future animal/keepsake previews: Tasks 3 and 7.
- Dog tease: Task 7 ending text.
- Save/reset: Tasks 3 and 8.
- Main menu/settings/window/fullscreen: Tasks 2 and 8.
- 1920x1080 Godot setup: Task 2.
- Placeholder-first implementation assumption: Tasks 6 and 9.
- Steamworks deferred: explicitly excluded from file structure and tasks.

Placeholder scan:

- No `TBD`, `TODO`, or "implement later" language remains.
- Deferred items are explicitly out of scope for this implementation plan.

Type consistency:

- Stage ids used by `SaveService`, `ShelterScene`, and tests are consistent: `not_started`, `first_rain`, `first_goodbye`, `second_rain`, `leaf_placement`, `codex_reveal`, `demo_complete`.
- Animal and keepsake ids are consistent: `kitten`, `leaf`, `dog`, `bird`, `hedgehog`, `glass_marble`, `feather`, `acorn`.
- Script paths match scene references.
