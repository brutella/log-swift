//
//  Logging.swift
//  Squares
//
//  Created by Matthias Hochgatterer on 03/12/14.
//  Copyright (c) 2014 Matthias Hochgatterer. All rights reserved.
//

import Foundation

// Send all messages to the shared logger instance
// The prefix is the current timestamp
public func print(_ string: String,
                  file: String = #file,
                  function: String = #function,
                  line: Int = #line) {
    let name = URL(fileURLWithPath: file).lastPathComponent
    Logger.sharedInstance.log(prefix() + ": \(name): \(function): \(line): " + string)
}

var _dateFormatter: DateFormatter?
func dateFormatter() -> DateFormatter {
    if _dateFormatter == nil {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd HH:mm:ss.SSS Z"
        _dateFormatter = dateFormatter
    }
    return _dateFormatter!
}

func prefix() -> String {
    return dateFormatter().string(from: Date())
}
