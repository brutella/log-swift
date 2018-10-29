# Log

Log provides a way to log stuff to the console and to file. It provides the method `Log.print()` which require minimal changes to your code because you probably already use `Swift.print()`.

## Example

This creates a file log output in the default logs directory (`path/to/application-support-dir/Logs`) with a name containing the current month and year (e.g. `18-10` for October 2018).

```swift
guard let dirURL = Logging.defaultLogsDirectoryURL() else {
	Swift.print("Logs directory not found")
	return
}
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "y-MM"

let fileName = "log-\(dateFormatter.string(from: Date()))"
let fileURL = dirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
let output = FileOutput(filePath: fileURL.path)
Logger.sharedInstance.addOutput(output)

Swift.print("Log file placed at \(fileURL.path)")
```
You can then start logging using `Log.print()`.

```swift
Log.print("Ups, something went wrong")
```

The log file will look like this

```text
2018-10-29 12:27:11.050 Ups, something went wrong

```

## Attach to emails

If a user reports an issue with your app, you can attach the log files to an email like this.

The following example uses the last 2 log files and attaches them to a mail compose sheet.

```swift
let mailController = MFMailComposeViewController()
if let urls = Logging.fileURLs { // returns the log files sorted by the creation date
	let fileManager = FileManager()
	for url in urls.prefix(2) {
		guard let data = fileManager.contents(atPath: url.path) else {
			continue
		}
		// Attach log as text file
		mailController.addAttachmentData(data, mimeType: "text/plain", fileName: url.lastPathComponent)
	}
}
```