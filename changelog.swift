#!/usr/bin/env xcrun swift

import Foundation

func incorrectUsage(usage: String) {
    print("Incorrect arguments. Usage : \(Process.arguments[0]) \(usage)")
}

func exitWithError(code: Int, _ message: String) {
    print("Error: \(message)")
    exit(Int32(code))
}

extension NSDate {
    func toFormat(format: String) -> String {
	let dateFormatter = NSDateFormatter()
	dateFormatter.dateFormat = format
	return dateFormatter.stringFromDate(self)
    }
}

func newVersion(version: String) {
    print("Create new version \(version) ... ", terminator: "")
    let currentPath =  NSFileManager.defaultManager().currentDirectoryPath
    let filePath = currentPath+"/CHANGELOG.md"
    var readme: String = ""
    do {
	readme = try String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
    } catch {
	exitWithError(2, "unable to read data from \(filePath)")
    } 
    let currentDate = NSDate().toFormat("yyyy-MM-dd")
    let versionTitle = "[\(version)] - \(currentDate)"

    readme = readme.stringByReplacingOccurrencesOfString("[Unreleased]", withString: versionTitle)
    readme = readme.stringByReplacingOccurrencesOfString("# Change Log", withString: "# Change Log\n\n## [Unreleased]\n\n")

    do {
	try readme.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
    } catch {
	exitWithError(3, "unable to write change to \(filePath)")
    }
 
    print("Done")
}

if Process.arguments.count < 3 {
    incorrectUsage("command options")
    exit(1)
}  

let command = Process.arguments[1]

if command == "new-version" {
    if Process.arguments.count < 3 {
    	incorrectUsage("new-version 1.3.3")
    	exit(1)
    }  
    let version = Process.arguments[2]
    newVersion(version)
}

exit(0)
