//
//  Searchable.swift
//  Scrape
//
//  Created by Sergej Jaskiewicz on 10.09.16.
//
//

/// Instances of conforming types can use XPath or CSS selectors to form a search request.
public protocol Searchable {
    
    /// Searches for a node from a current node by provided XPath.
    ///
    /// - parameter xpath:      XPath to search by.
    /// - parameter namespaces: XML namespace to search in. Default value is `nil`.
    ///
    /// - returns: `XPath` enum case with an associated value.
    func search(byXPath xpath: String, namespaces: [String : String]?) -> XPathResult
    
    /// Searches for a node from a current node by provided XPath and returns the first match.
    ///
    /// - parameter xpath:      XPath to search by.
    /// - parameter namespaces: XML namespace to search in. Default value is `nil`.
    ///
    /// - returns: The first element matching given XPath. `nil` if XPath does not contain any nodes.
    func atXPath(_ xpath: String, namespaces: [String : String]?) -> XMLElement?
    
    // TODO: Remove this check when NSRegularExpression is fully supported on Linux
    #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    /// Searches for a node from a current node by provided CSS selector.
    ///
    /// - parameter selector:   CSS selector to search by.
    /// - parameter namespaces: XML namespace to search in. Default value is `nil`.
    ///
    /// - returns: `XPath` enum case with an associated value.
    func search(byCSSSelector selector: String, namespaces: [String : String]?) -> XPathResult
    
    /// Searches for a node from a current node by provided CSS selector and returns the first match.
    ///
    /// - parameter selector:   CSS selector to search by.
    /// - parameter namespaces: XML namespace to search in. Default value is `nil`.
    ///
    /// - returns: The first element matching given selector. `nil` if corresponding XPath does not
    /// contain any nodes.
    func atCSSSelector(_ selector: String, namespaces: [String : String]?) -> XMLElement?
    #endif
}

public extension Searchable {
    
    /// Searches for a node from a current node by provided XPath.
    ///
    /// - parameter xpath:      XPath to search by.
    ///
    /// - returns: `XPath` enum case with an associated value.
    public final func search(byXPath xpath: String) -> XPathResult {
        return search(byXPath: xpath, namespaces: nil)
    }
    
    /// Searches for a node from a current node by provided XPath and returns the first match.
    ///
    /// - parameter xpath:      XPath to search by.
    /// - parameter namespaces: XML namespace to search in. Default value is `nil`.
    ///
    /// - returns: The first element matching given XPath. `nil` if XPath does not contain any nodes.
    public final func atXPath(_ xpath: String, namespaces: [String : String]?) -> XMLElement? {
        return search(byXPath: xpath, namespaces: namespaces).nodeSetValue.first
    }
    
    /// Searches for a node from a current node by provided XPath and returns the first match.
    ///
    /// - parameter xpath:      XPath to search by.
    ///
    /// - returns: The first element matching given XPath. `nil` if XPath does not contain any nodes.
    public final func atXPath(_ xpath: String) -> XMLElement? {
        return atXPath(xpath, namespaces: nil)
    }
    
    // TODO: Remove this check when NSRegularExpression is fully supported on Linux
    #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    /// Searches for a node from a current node by provided CSS selector.
    ///
    /// - parameter selector:   CSS selector to search by.
    ///
    /// - returns: `XPath` enum case with an associated value.
    public final func search(byCSSSelector selector: String) -> XPathResult {
        return search(byCSSSelector: selector, namespaces: nil)
    }
    
    /// Searches for a node from a current node by provided CSS selector and returns the first match.
    ///
    /// - parameter selector:   CSS selector to search by.
    /// - parameter namespaces: XML namespace to search in. Default value is `nil`.
    ///
    /// - returns: The first element matching given selector. `nil` if corresponding XPath does not
    /// contain any nodes.
    public final func atCSSSelector(_ selector: String, namespaces: [String : String]?) -> XMLElement? {
        return search(byCSSSelector: selector, namespaces: namespaces).nodeSetValue.first
    }
    
    /// Searches for a node from a current node by provided CSS selector and returns the first match.
    ///
    /// - parameter selector:   CSS selector to search by.
    ///
    /// - returns: The first element matching given selector. `nil` if corresponding XPath does not
    /// contain any nodes.
    public final func atCSSSelector(_ selector: String) -> XMLElement? {
        return atCSSSelector(selector, namespaces: nil)
    }
    #endif
}
