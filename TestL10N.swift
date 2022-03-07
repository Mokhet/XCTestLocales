import XCTest
@testable import MyApplication

class TestL10N: XCTestCase
{
 let baseLocale: String = "en"
 let locales: [ String ] = [ "en", "fr", "es", "de" ]

 func testBundleDefined()
 {
  for locale in locales
  {
   if getBundle(for: locale) == nil
   {
    XCTFail("Missing file localization for \(locale)")
   }
  }
 }

 func testNoMissingTranslation()
 {
  guard let baseBundle = getBundleKeys(for: baseLocale)
  else
  {
   XCTFail("Missing file \"Localizable.strings (\(baseLocale)\"")
   return
  }

  let locales = locales.filter { $0 != baseLocale }
  for locale in locales
  {
   if let localeBundle = getBundleKeys(for: locale)
   {
    var diff = baseBundle.filter { !localeBundle.contains($0) }
    XCTAssert(diff.isEmpty,
              "Missing keys (\(diff.count)) in \"Localizable.strings (\(locale))\"\n\(diff.map { " - " + $0 }.joined(separator: "\n"))")

    diff = localeBundle.filter { !baseBundle.contains($0) }
    XCTAssert(diff.isEmpty,
              "Excessive keys (\(diff.count)) in \"Localizable.strings (\(locale))\"\n\(diff.map { " - " + $0 }.joined(separator: "\n"))")
   }
   else
   {
    XCTFail("Missing Localizable.strings (\(locale))")
   }
  }
 }
}

extension TestL10N
{
 func getBundle(for localeId: String) -> Bundle?
 {
  guard let path = Bundle.main.path(forResource: localeId, ofType: "lproj"),
        let bundle = Bundle(path: path)
  else { return nil }

  return bundle
 }

 func getBundleKeys(for localeId: String) -> [String]?
 {
  guard let bundle = getBundle(for: localeId),
        let url = bundle.url(forResource: "Localizable", withExtension: "strings", subdirectory: nil),
        let dict = NSDictionary(contentsOf: url) as? [String: String]
  else { return nil }

  return Array(dict.keys)
 }
}
