//
//  StatusBarController.swift
//  Casey
//
//  Created by Stuart Wallace on 3/11/22.
//

import Foundation
import AppKit
import Cocoa


enum MenuStatus {
    case open
    case animating
    case closed
}

class StatusBarController {

    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var menuStatus = MenuStatus.closed
    private var popoverWindow: NSWindow? { popover.contentViewController?.view.window }
    
    init(with popover: NSPopover) {
        self.popover = popover
        self.popover.animates = false
        statusBar = NSStatusBar.init()
        statusItem = statusBar.statusItem(withLength: statusBar.c)
        
        if let statusBarButton = statusItem.button {
            statusBarButton.image = NSImage(systemSymbolName: "pencil.circle", accessibilityDescription: nil)
            statusBarButton.image?.size = NSSize(width: statusBar.thickness, height: statusBar.thickness)
            statusBarButton.image?.isTemplate = true
            statusBarButton.action = #selector(statusBarButtonTouched(sender:))
            statusBarButton.target = self
        }
    }
    
    public func globalLeftMouseDown(at location: NSPoint) {
        guard let button = statusItem.button else { return }
        hidePopover(button)
    }

    @objc func statusBarButtonTouched(sender: AnyObject) {
        switch menuStatus {
        case .open:
            hidePopover(sender)
        case .animating:
            openWhileAnimatingClosed(sender: sender)
        case .closed:
            showPopover(sender)
        }
    }
    
    func openWhileAnimatingClosed(sender: AnyObject) {
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.01
            popover.contentViewController?.view.window?.animator().alphaValue = 0
        }, completionHandler: {
            self.popover.contentViewController?.view.window?.animator().alphaValue = 1.0
            self.showPopover(sender)
        })
    }
    
    func showPopover(_ sender: AnyObject) {
        let positioningView = NSView(frame: sender.bounds)
        positioningView.identifier = NSUserInterfaceItemIdentifier(rawValue: "positioningView")
        sender.addSubview(positioningView)
        popover.show(relativeTo: positioningView.bounds, of: positioningView, preferredEdge: .maxX)
       
        guard let senderBounds = sender.bounds else { return }
        sender.setBoundsOrigin(senderBounds.offsetBy(dx: 0, dy: sender.bounds.height).origin)
        guard let offsetWindowOrigin = popoverWindow?.frame.offsetBy(dx: -statusBar.thickness * 1.5, dy: 13).origin else { return }
        popoverWindow?.setFrameOrigin(offsetWindowOrigin)
        menuStatus = .open
    }

    func hidePopover(_ sender: AnyObject) {
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            menuStatus = .animating
            context.duration = 0.2
            popoverWindow?.animator().alphaValue = 0
        }, completionHandler: {
            self.menuStatus = .closed
            self.popover.performClose(sender)
            self.popoverWindow?.animator().alphaValue = 1
        })
    }
    
}
