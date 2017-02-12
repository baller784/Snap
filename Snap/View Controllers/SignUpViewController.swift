//
//  SignUpViewController.swift
//  Snap
//
//  Created by Daniel Marcenco on 12/15/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    fileprivate let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20.0
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    fileprivate let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email"
        textField.returnKeyType = .next
        textField.keyboardType = .emailAddress
        return textField
    }()
    fileprivate let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        return textField
    }()
    fileprivate let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    fileprivate let haveAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back to Sign In", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
}

//MARK: Setup
extension SignUpViewController {
    func setup() {
        signUpButton.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
        haveAccountButton.addTarget(self, action: #selector(backToLoginPressed), for: .touchUpInside)
    }

    @objc fileprivate func registerPressed() {
        let email = emailTextField.text
        let password = passwordTextField.text
        FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user, error) in
            if let error = error {
                if let errCode = FIRAuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        self.showAlert("Enter a valid email.")
                    case .errorCodeEmailAlreadyInUse:
                        self.showAlert("Email already in use.")
                    default:
                        self.showAlert("Error: \(error.localizedDescription)")
                    }
                }
                return
            }
            self.signIn()
        })
    }

    @objc fileprivate func backToLoginPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    func signIn() {
        UIApplication.appDelegate.switchToMainViewController()
    }

    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Snap", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK: Layout
extension SignUpViewController: Layoutable {
    func layout() {
        view.addSubview(stackView)
        [emailTextField, passwordTextField, signUpButton, haveAccountButton].forEach { stackView.addArrangedSubview($0) }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80.0)
            make.width.equalToSuperview()
        }

        emailTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(40.0)
        }

        passwordTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(40.0)
        }

        signUpButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(40.0)
        }

        haveAccountButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(80)
            make.right.equalToSuperview().offset(-80)
        }
    }
}
