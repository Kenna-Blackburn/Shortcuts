
# SPM/Shortcuts

## Usage Example

```swift
struct DebugShortcut: Shortcut {
  var body: some ActionGroup {
    Comment("""
    v0.0.1
    Made by Kenna Blackburn on 02/11/26 with SPM/Shortcuts
    """)

    var payload = MagicVariable()
    AskFor.Text(
      with: "Payload",
      default: "The Answer to the Great Question... Of Life, the Universe and Everything... Is... Forty-two,' said Deep Thought, with infinite majesty and calm.",
      multiline: true,
    )
    .bind(to: &payload)

    var target = MagicVariable()
    SelectContacts(multiple: true)
      .bind(to: &target)

    var splitText = MagicVariable()
    SplitText(payload, by: " ")
      .bind(to: &splitText)

    RepeatEach(splitText) { (i, token) in
      ShowResult(token)
    }
  }
}
```

```swift
let url = URL.downloadsDirectory.appending(path: "DebugShortcut.shortcut")
try await DebugShortcut().compile(to: url, using: .cli())
```

https://www.icloud.com/shortcuts/c4c73cf03401482c9936638bb9a0731c

## Todo

- [ ] More Actions
- [ ] Aggrandizements
- [ ] Tick Repeat Index/Item
- [ ] `instanceID` rt errors?
