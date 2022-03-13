//
//  AppDelegate.swift
//  Casey
//
//  Created by Stuart Wallace on 3/9/22.
//

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {

    var popover = NSPopover.init()
    var popoverTwo = NSPopover.init()
    var statusBarController: StatusBarController?
    var globalObserver: Any!
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.setContentSize(.zero)
            window.close()
        }
        popover.contentViewController = EmptyViewController()
        statusBarController = StatusBarController.init(with: popover)
        
        globalObserver = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { event in
            self.statusBarController?.globalLeftMouseDown(at: event.locationInWindow)
        }
    }
}

class EmptyViewController: NSViewController {
    init() { super.init(nibName: nil, bundle: nil) }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func loadView() {
        self.view = RedView()
        view.frame = .init(x: 0, y: 0, width: 100, height: 100)
    }
}

class RedView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor(red: 180/255, green: 52/255, blue: 24/255, alpha: 1).setFill()
        dirtyRect.fill()
    }
}
