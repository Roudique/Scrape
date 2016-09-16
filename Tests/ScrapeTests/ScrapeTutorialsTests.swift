//
//  ScrapeTutorialsTests.swift
//  Scrape
//
//  Created by Atsushi Kiwaki on 6/27/16.
//  Copyright © 2016 tid. All rights reserved.
//

import XCTest
import Foundation
import Scrape

class ScrapeTutorialsTests: XCTestCase {
    
    static var allTests = {
        return [
            ("testParsingFromString", testParsingFromString),
            ("testParsingFromFile", testParsingFromFile),
            ("testParsingFromInternets", testParsingFromInternets),
            ("testParsingFromEncoding", testParsingFromEncoding),
            ("testParsingOptions", testParsingOptions),
            ("testSearchingBasicSearching", testSearchingBasicSearching),
            ("testSearchingNamespaces", testSearchingNamespaces)
        ]
    }()
    
    func testParsingFromString() {
        let html = "<html>"                 +
                     "<body>"               +
                       "<h1>Tutorials</h1>" +
                     "</body>"              +
                   "</html>"
        
        if let htmlDoc = HTMLDocument(html: html, encoding: .utf8) {
            XCTAssert(htmlDoc.html != nil)
        }
        
        let xml = "<root>"                      +
                    "<item>"                    +
                      "<name>Tutorials</name>"  +
                    "</item>"                   +
                  "</root>"
        
        if let xmlDoc = XMLDocument(xml: xml, encoding: .utf8) {
            XCTAssert(xmlDoc.html != nil)
        }
        
    }
    
    func testParsingFromFile() {
        let filename = "test_HTML4.html"
        let filePath = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent(filename)
        
        let data = try! Data(contentsOf: filePath)
        if let doc = HTMLDocument(html: data, encoding: .utf8) {
            XCTAssert(doc.html != nil)
        }
        
        let html = try! String(contentsOf: filePath)
        if let doc = HTMLDocument(html: html, encoding: .utf8) {
            XCTAssert(doc.html != nil)
        }
    }
    
    func testParsingFromInternets() {
        let url = URL(string: "https://en.wikipedia.org/wiki/Cat")
        if let doc = HTMLDocument(url: url!, encoding: .utf8) {
            XCTAssert(doc.html != nil)
        }
    }
    
    func testParsingFromEncoding() {
        
        let html = "<html>"                 +
                     "<body>"               +
                       "<h1>Tutorials</h1>" +
                     "</body>"              +
                   "</html>"
        
        if let htmlDoc = HTMLDocument(html: html, encoding: .japaneseEUC) {
            XCTAssert(htmlDoc.html != nil)
        }
    }
    
    func testParsingOptions() {
        let html = "<html>"                 +
                     "<body>"               +
                       "<h1>Tutorials</h1>" +
                     "</body>"              +
                   "</html>"
        
        if let doc = HTMLDocument(html: html, encoding: .utf8, options: .strict) {
            XCTAssert(doc.html != nil)
        }
    }
    
    func testSearchingBasicSearching() {
        let TestVersionData = [
            "iOS 10",
            "iOS 9",
            "iOS 8",
            "macOS 10.12",
            "macOS 10.11",
            "tvOS 10.0",
            ]
        
        let TestVersionDataIOS = [
            "iOS 10",
            "iOS 9",
            "iOS 8",
            ]
        let filename = "versions.xml"
        let filePath = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent(filename)
        let xml = try! String(contentsOf: filePath)
        if let doc = XMLDocument(xml: xml, encoding: .utf8) {
            for (i, node) in doc.search(byXPath: "//name").enumerated() {
                XCTAssert(node.text! == TestVersionData[i])
            }
            
            let nodes = doc.search(byXPath: "//name")
            XCTAssert(nodes[0].text! == TestVersionData[0])
            
            for (i, node) in doc.search(byXPath: "//ios//name").enumerated() {
                XCTAssert(node.text! == TestVersionDataIOS[i])
            }
            

            #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
            for (i, node) in doc.search(byCSSSelector: "ios name").enumerated() {
                XCTAssert(node.text! == TestVersionDataIOS[i])
            }
            
            XCTAssertEqual(doc.search(byCSSSelector: "tvos name").first!.text, "tvOS 10.0")
            XCTAssertEqual(doc.atCSSSelector("tvos name")?.text, "tvOS 10.0")
            #endif
        }
    }
    
    func testSearchingNamespaces() {
        let TestLibrariesDataGitHub = [
            "Kanna",
            "Alamofire",
            ]
        
        let TestLibrariesDataBitbucket = [
            "Hoge",
            ]
        
        let filename = "libraries.xml"
        let filePath = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent(filename)
        
        let xml = try! String(contentsOf: filePath)
        if let doc = XMLDocument(xml: xml, encoding: .utf8) {
            
            for (i, node) in doc.search(byXPath: "//github:title",
                                        namespaces: ["github" : "https://github.com/"]).enumerated() {
                XCTAssert(node.text! == TestLibrariesDataGitHub[i])
            }
        }
        
        if let doc = XMLDocument(xml: xml, encoding: .utf8) {
            
            for (i, node) in doc.search(byXPath: "//bitbucket:title",
                                        namespaces: ["bitbucket": "https://bitbucket.org/"]).enumerated() {
                                            XCTAssert(node.text! == TestLibrariesDataBitbucket[i])
            }
        }
    }
    

    #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    func testModifyingChangingTextContents() {
        
        let TestModifyHTML = "<body>\n"                             +
                             "    <h1>Snap, Crackle &amp; Pop</h1>\n" +
                             "    <div>A love triangle.</div>\n"      +
                             "</body>"
        
        let filename = "sample.html"
        let filePath = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent(filename)
        
        let html = try! String(contentsOf: filePath)
        guard let doc = HTMLDocument(html: html, encoding: .utf8) else {
            XCTAssert(false, "File not found. name: (\(filename))")
            return
        }
        
        var h1 = doc.atCSSSelector("h1")!
        h1.content = "Snap, Crackle & Pop"
        
        XCTAssertEqual(doc.body?.html, TestModifyHTML)
    }
    #endif
    

    #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    func testModifyingMovingNode() {
        
        let TestModifyHTML = "<body>\n"                                                 +
                             "    \n"                                                   +
                             "    <div>A love triangle.<h1>Three\'s Company</h1>\n"     +
                             "</div>\n"                                                 +
                             "</body>"
        
        let TestModifyArrangeHTML = "<body>\n"                          +
                                    "    \n"                              +
                                    "    <div>A love triangle.</div>\n"   +
                                    "<h1>Three\'s Company</h1>\n"     +
                                    "</body>"
        
        let filename = "sample.html"
        let filePath = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent(filename)
        let html = try! String(contentsOf: filePath)
        guard let doc = HTMLDocument(html: html, encoding: .utf8) else {
            return
        }
        var h1  = doc.atCSSSelector("h1")!
        let div = doc.atCSSSelector("div")!
        
        h1.parent = div
        
        XCTAssertEqual(doc.body?.html, TestModifyHTML)

        div.addNextSibling(h1)
        
        XCTAssertEqual(doc.body?.html, TestModifyArrangeHTML)
    }
    
    func testModifyingNodesAndAttributes() {
        
        let TestModifyHTML = "<body>\n"                                             +
                             "    <h2 class=\"show-title\">Three\'s Company</h2>\n"   +
                             "    <div>A love triangle.</div>\n"                      +
                             "</body>"
        
        let filename = "sample.html"
        let filePath = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent(filename)
        let html = try! String(contentsOf: filePath)
        guard let doc = HTMLDocument(html: html, encoding: .utf8) else {
            return
        }
        var h1  = doc.atCSSSelector("h1")!
        
        h1.tagName = "h2"
        h1["class"] = "show-title"
        
        XCTAssertEqual(doc.body?.html, TestModifyHTML)
    }
    #endif
}