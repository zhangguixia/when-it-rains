# When It Rains / 当雨落下时 - Steam Demo Design

Date: 2026-05-30
Status: Design confirmed in conversation; awaiting final written-spec review
Target: Steam Demo / Next Fest-style playable slice

## Product Positioning

**English title:** When It Rains

**Chinese title:** 当雨落下时

**Steam short description:** A cozy shelter game about helping little animals through rainy days.

The demo is a quiet, emotional 15-30 minute slice about offering a small act of care and discovering that it mattered. The core emotional arc is not "collect many things"; it is "it remembered me."

The demo should leave players with three clear impressions:

1. A wet, hesitant kitten needed a safe place.
2. The player's simple care changed how the kitten behaved.
3. When the kitten returned, the player understood that their kindness had been remembered.

## Scope Choice

The chosen route is an authored kitten-first Steam Demo slice.

The demo includes:

- One complete two-visit kitten arc.
- Low-pressure light management around dry areas, cushion placement, milk, and petting.
- One keepsake: a leaf.
- A fixed-slot keepsake placement moment in a small shelter corner.
- An animal + keepsake codex.
- A locked preview of future animals and keepsakes.
- A small dog tease through sound, silhouette, pawprints, or another non-playable hint.

The demo excludes:

- Full multi-animal loops.
- Freeform decoration.
- Shops, upgrades, purchases, or consumable resources.
- Failure conditions.
- Complex daily scheduling.
- Full Steamworks integration. Wishlist prompts are handled as in-game text in this demo scope.

## Demo Experience

The demo plays across two rainy visits.

### First Rain

The player starts under an empty eave or window-side shelter while rain falls outside. A wet kitten appears and hesitates before entering. The player learns the core interactions through discovery and gentle visual cues:

- Drag the cushion to a safer, drier area.
- Click the milk bowl to pour milk.
- Click the kitten to pet it.

The kitten starts cold and uncertain. As the player cares for it, the kitten becomes calmer, moves closer, drinks milk, rests, and eventually accepts the shelter.

When the rain stops, the kitten leaves. This should not feel like a failure. The departure is framed as a natural goodbye: the kitten turns back once before disappearing. It leaves a leaf behind as the first keepsake.

### Second Rain

After a short transition, rain returns. The kitten comes back.

The return must read as recognition, not random respawn. The kitten should hesitate less, move toward the previous comfort area, or react to the milk bowl/cushion with familiarity.

The player cares for the kitten again with the same low-pressure interactions. The second visit confirms the emotional premise: the player's small kindness mattered.

### Ending

At the end of the second visit, the player unlocks a small shelter corner. The player drags the leaf to one of 2-3 fixed display slots. This gives the player a brief but meaningful act of participation without creating a full decoration system.

The codex opens after the leaf is placed:

- The kitten entry is complete.
- The leaf keepsake entry is complete.
- Other animals, such as dog, bird, and hedgehog, appear as locked silhouettes.
- Other keepsakes appear as locked silhouettes.

The demo ends with a light future-content tease. The preferred tease is non-committal and low-cost, such as a distant bark, a shadow outside the shelter, or wet pawprints near the edge of the scene.

## Core Interactions

### Cushion Placement

The player can drag the cushion between 2-3 valid areas under the eave. Areas have an internal dryness value, but the UI does not show hard numbers. Wetness changes the kitten's comfort behavior and pacing, not whether the player can win.

The player should understand the system through rain visuals, floor shine, drips, and the kitten's body language.

### Milk Bowl

Clicking the milk bowl pours milk and triggers a small animation or particle effect. Milk is not a purchased or limited resource in the demo.

The kitten can approach and drink after milk is poured. Drinking should produce a small sound and a visible comfort response.

### Petting

Clicking the kitten triggers a short petting response, such as a small animation, expression shift, or purring sound. Internally, petting increases trust, but the player never sees a numeric affection meter.

Petting should be gentle and paced to avoid becoming a clicker mechanic.

### Keepsake Placement

After the kitten leaves the leaf, the player can drag the leaf into one of 2-3 fixed slots in the shelter corner. The selected slot is saved.

This is the first hint of long-term collection and display. It is not a full garden or housing editor.

## Systems

### Weather Flow

The demo uses an authored weather sequence rather than a fully random weather simulation:

1. Intro rain.
2. First rain care sequence.
3. Rain stop and kitten departure.
4. Short interlude.
5. Second rain and kitten return.
6. Ending and codex reveal.

Rain intensity can vary for atmosphere, but the sequence should remain predictable for demo pacing.

### Animal State

The kitten uses a small state machine:

- `Hesitating`
- `Approaching`
- `Resting`
- `Drinking`
- `Purring`
- `Leaving`
- `Returning`

State transitions respond to cushion placement, milk availability, petting, weather stage, and authored timing.

The full game can later add other animals using the same profile and state interfaces, but the demo only needs the kitten fully implemented.

### Care State

Care state tracks:

- Cushion location.
- Area dryness.
- Milk bowl state.
- Petting count or trust contribution.
- Current visit number.

These values influence animation, dialogue text, and pacing. They are not surfaced as visible stats.

### Codex

The codex combines animal and keepsake collection.

Demo-visible entries:

- Kitten: unlocked, with two-visit completion.
- Leaf: unlocked, with a short keepsake text.
- Dog, bird, hedgehog: locked silhouettes.
- Future keepsakes: locked silhouettes.

The codex should communicate future content without implying those animals are playable in the demo.

### Saving

The demo saves:

- Current demo stage.
- Whether the kitten has visited once or twice.
- Whether the leaf has been collected.
- Leaf display slot.
- Codex unlock state.
- Basic settings.

If save data is corrupted, the game should allow a demo reset rather than crashing.

## Godot Architecture

Target engine: Godot 4.x, with Godot 4.6.2 as the intended project version.

Recommended scene structure:

- `Main.tscn`: startup entry, settings/save initialization, scene loading.
- `ShelterScene.tscn`: main playable scene with background, rain, cushion, milk bowl, kitten, interaction hotspots, and demo flow.
- `CatActor.tscn`: kitten visuals, animations, and state machine.
- `CodexPanel.tscn`: animal + keepsake codex UI.
- `KeepsakeCorner.tscn`: fixed-slot leaf placement UI/scene element.

Recommended scripts:

- `WeatherController.gd`: rain sequence, rain stop, visual/audio weather cues.
- `CareController.gd`: cushion, milk, petting, and dry-area state.
- `CatStateMachine.gd`: kitten state transitions and behavior.
- `KeepsakeController.gd`: leaf creation and placement.
- `CodexService.gd`: codex unlock state and entry data.
- `SaveService.gd`: persistent demo progress and settings.

Recommended resource types:

- `AnimalProfile`
- `KeepsakeProfile`
- `DialogueLine`
- `DemoStageConfig`

Content should be data-driven where it helps future expansion, but the demo should not overbuild generic systems before the kitten arc works.

## Visual Direction

The visual direction is low-saturation hand-painted watercolor with warm yellow shelter light and rainy window/eave atmosphere.

The first screen should immediately communicate:

- It is raining.
- This is a safe shelter space.
- The kitten is wet and uncertain.
- The player can make the space more comfortable.

Required demo assets:

- One 16:9 shelter/eave/window background.
- One kitten design with at least four readable states: wet/hesitant, resting, drinking, leaving/looking back.
- Cushion.
- Milk bowl.
- Leaf keepsake.
- Small shelter corner with 2-3 fixed display slots.
- Codex UI with kitten, leaf, and locked silhouettes.
- A low-cost dog tease asset or audio cue.

## Audio Direction

Audio should be quiet and intimate. Rain is the main bed.

Required demo audio:

- Looping rain ambience.
- Rain-stop transition or lighter rain layer.
- Occasional subtle thunder.
- Milk pour sound.
- Drinking sound.
- Petting or purring sound.
- Small movement or leaving sound.
- Optional sparse music for the ending or codex reveal.
- Optional distant dog bark for the final tease.

Music should not overpower the rain. Silence and small sounds are part of the emotional design.

## UI and Settings

The demo needs:

- Main menu.
- Start or continue.
- Settings.
- Reset demo progress.
- Exit game.
- Codex panel.
- Minimal in-game prompts or visual hints.

Settings should cover at least:

- Master volume.
- Ambience/rain volume.
- Music volume.
- Window/fullscreen toggle.

UI should support 1920x1080 and scale cleanly when windowed.

## Steam Demo Deliverables

Primary deliverable:

- Windows playable demo build.

Deferred deliverables:

- macOS build.
- Web build for itch.io.

Store and marketing capture targets:

- Rainy shelter first screen.
- Kitten drinking milk.
- Kitten leaving as rain stops.
- Leaf placement in the shelter corner.
- Codex page with kitten unlocked and other animals silhouetted.

The demo can include an ending screen inviting players to wishlist the full game, but Steamworks integration is not required for this design phase.

## Testing

### Emotional Tests

The demo should pass these checks:

1. Players understand the kitten needs a dry, safe place.
2. Players discover cushion, milk, and petting interactions within about one minute without heavy tutorial text.
3. The first departure reads as a gentle goodbye, not failure.
4. The second visit reads as the same kitten returning.
5. The leaf placement and codex reveal make future collection understandable.

### Technical Tests

The demo should pass these checks:

1. New game to demo ending works without blockers.
2. Exiting and reopening restores the nearest meaningful stage.
3. Window resizing does not hide critical UI or interaction targets.
4. Missing assets use placeholders or log errors instead of crashing.
5. Reset progress works.

### Playtest Success Criteria

For an initial 5-8 player test:

- At least 70% finish the demo without explanation.
- At least 60% mention emotional recognition, such as "it came back," "it remembered me," or "I felt a little reluctant to say goodbye."
- Players can describe the future promise as more animals and more keepsakes.

## Implementation Assumptions

Implementation planning should proceed with these assumptions:

- Godot 4.6.2 is the target version. If the local machine has a different Godot 4.x version, the first implementation step is to verify compatibility before creating project-specific assets.
- The first playable build uses simple placeholder art where needed. AI-generated or final-styled assets are added after the core loop works.
- Steam-specific packaging is deferred until the demo loop, saving, settings, codex, and ending are playable locally.

The recommended implementation order is playable loop first, then art/audio pass, then codex and Steam-demo polish.
