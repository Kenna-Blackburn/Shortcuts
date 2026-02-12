//
//  CLISigningService.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/11/26.
//

import Foundation

#if os(macOS)
public final class CLISigningService: SigningService {
    public var target: Target
    
    public init(for target: Target = .anyone) {
        self.target = target
    }
    
    public func sign(
        _ shortcut: RawShortcut,
        to outputURL: URL
    ) async throws {
        let data = try PropertyListEncoder().encode(shortcut)
        
        let tempURL = URL.temporaryDirectory.appending(path: "\(UUID()).shortcut")
        try data.write(to: tempURL)
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/shortcuts")
        process.arguments = [
            "sign",
            "-m", target.rawValue,
            "-i", tempURL.path(),
            "-o", outputURL.path(),
        ]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        
        try process.run()
        process.waitUntilExit()
        
        let responseData = pipe.fileHandleForReading.readDataToEndOfFile()
        if let response = String(data: responseData, encoding: .utf8) {
            print(response)
        }
    }
}

extension CLISigningService {
    public enum Target: String {
        case anyone = "anyone"
        case peopleWhoKnowMe = "people-who-know-me"
    }
}

extension SigningService where Self == CLISigningService {
    static func cli(for target: Self.Target = .anyone) -> Self {
        CLISigningService(for: target)
    }
}
#endif
