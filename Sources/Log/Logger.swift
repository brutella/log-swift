//
//  File.swift
//  Squares
//
//  Created by Matthias Hochgatterer on 03/12/14.
//  Copyright (c) 2014 Matthias Hochgatterer. All rights reserved.
//

import Foundation
import Dispatch
import Swift

public protocol Output {
    func process(_ string: String)
}

public struct ConsoleOutput: Output {
    private var queue: DispatchQueue
    
    public init() {
        self.queue = DispatchQueue(label: "Console output")
    }
    
    public func process(_ string: String) {
        queue.sync {
            Swift.print(string)
        }
    }
}

public class FileOutput: Output {
    var filePath: String
    private var fileHandle: FileHandle?
    private var queue: DispatchQueue
    
    public init(filePath: String) {
        self.filePath = filePath
        self.queue = DispatchQueue(label: "File output")
    }
    
    deinit {
        fileHandle?.closeFile()
    }
    
    public func process(_ string: String) {
        queue.sync(execute: {
            [weak self] in
            if let file = self?.getFileHandle() {
                let printed = string + "\n"
                if let data = printed.data(using: String.Encoding.utf8) {
                    file.seekToEndOfFile()
                    file.write(data)
                }
            }
        })
    }
    
    
    private func getFileHandle() -> FileHandle? {
        if fileHandle == nil {
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: filePath) {
                fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
            }
            
            fileHandle = FileHandle(forWritingAtPath: filePath)
        }
        
        return fileHandle
    }
}

public class URLOutput: Output {
    var url: URL
    private var fileHandle: FileHandle?
    private var queue: DispatchQueue
    
    public init(url: URL) {
        self.url = url
        self.queue = DispatchQueue(label: "URL output")
    }
    
    deinit {
        fileHandle?.closeFile()
    }
    
    public func process(_ string: String) {
        queue.sync(execute: {
            [weak self] in
            if let file = self?.getFileHandle() {
                let printed = string + "\n"
                if let data = printed.data(using: String.Encoding.utf8) {
                    file.seekToEndOfFile()
                    file.write(data)
                }
            }
        })
    }
    
    
    private func getFileHandle() -> FileHandle? {
        if fileHandle == nil {
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: url.absoluteString) {
                fileManager.createFile(atPath: url.absoluteString, contents: nil, attributes: nil)
            }
            
            do {
                fileHandle = try FileHandle(forWritingTo: url)
            } catch let error {
                Swift.print(error.localizedDescription)
            }
        }
        
        return fileHandle
    }
}

private let _sharedInstance = Logger()
public class Logger {
    public class var sharedInstance: Logger {
        return _sharedInstance
    }
    private var outputs: [Output]
    
    public init() {
        outputs = [Output]()
        outputs.append(ConsoleOutput())
    }
    
    public func addOutput(_ output: Output) {
        outputs.append(output)
    }
    
    public func log(_ string: String) {
        for out in outputs {
            out.process(string)
        }
    }
}
