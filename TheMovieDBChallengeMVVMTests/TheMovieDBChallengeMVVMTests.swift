//
//  TheMovieDBChallengeMVVMTests.swift
//  TheMovieDBChallengeMVVMTests
//
//  Created by Kevin Candia Villagómez on 19/08/23.
//

import XCTest
@testable import TheMovieDBChallengeMVVM

final class TheMovieDBChallengeMVVMTests: XCTestCase {
    var sut: MovieLoginViewController!

    override func setUpWithError() throws {
        let viewController: MovieLoginViewController = MovieLoginViewController.loadFromNib()
        sut = viewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testLoginTextFieldsAreEmpty() throws {
        let user = try XCTUnwrap(sut.userTextField)
        let password = try XCTUnwrap(sut.passwordTextField)
        guard let usuario = user.text, let pass = password.text else { return }
        XCTAssertEqual(user.text, usuario,"El campo email debe estar vacio")
        XCTAssertEqual(password.text, pass, "El campo passsword debe estar vacio")
    }
    
    func testLoginTextFieldsAreFilled() throws {
        let user = try XCTUnwrap(sut.userTextField)
        let password = try XCTUnwrap(sut.passwordTextField)
        guard let usuario = user.text, let pass = password.text else { return }
        XCTAssertEqual(user.text, usuario, "El campo email esta lleno")
        XCTAssertEqual(password.text, pass, "El campo passsword esta lleno")
    }
    
    func testLoginUserTextFieldTypeKeyboard() throws {
        let user = try XCTUnwrap(sut.userTextField)
        XCTAssertEqual(user.keyboardType, .emailAddress, "El tipo de teclado debe ser emailAddress")
    }
    
    func testLoginPasswordTextFieldIsSecureEntry() throws {
        let password = try XCTUnwrap(sut.passwordTextField)
        XCTAssertTrue(password.isSecureTextEntry, "El textfield password no contiene entrada segura")
    }

}
