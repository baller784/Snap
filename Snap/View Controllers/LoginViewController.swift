//
//  LoginViewController.swift
//  Snap
//
//  Created by Daniel Marcenco on 12/15/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
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
    fileprivate let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    fileprivate let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    fileprivate let forgotPassword: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    fileprivate func checkCurrenUser() {
        if let _ = FIRAuth.auth()?.currentUser {
            self.signIn()
        }
    }
}

// MARK: Setup 
extension LoginViewController {
    fileprivate func setup() {
//        passwordTextField.delegate = self
        signInButton.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
        forgotPassword.addTarget(self, action: #selector(passwordReset), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
    }

    @objc fileprivate func signInPressed() {
        let email = emailTextField.text
        let password = passwordTextField.text
        FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user, error) in
            guard let _ = user else {
                if let error = error {
                    if let errCode = FIRAuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .errorCodeUserNotFound:
                            self.showAlert("User account not found. Try registering")
                        case .errorCodeWrongPassword:
                            self.showAlert("Incorrect username/password combination")
                        default:
                            self.showAlert("Error: \(error.localizedDescription)")
                        }
                    }
                    return
                }
                return assertionFailure("user and error are nil")
            }
            self.signIn()
        })
    }

    @objc fileprivate func passwordReset() {
        let prompt = UIAlertController(title: "Snap", message: "Email:", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            FIRAuth.auth()?.sendPasswordReset(withEmail: userInput!, completion: { (error) in
                if let error = error {
                    if let errCode = FIRAuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .errorCodeUserNotFound:
                            DispatchQueue.main.async {
                                self.showAlert("User account not found. Try registering")
                            }
                        default:
                            DispatchQueue.main.async {
                                self.showAlert("Error: \(error.localizedDescription)")
                            }
                        }
                    }
                    return
                } else {
                    DispatchQueue.main.async {
                        self.showAlert("You'll receive an email shortly to reset your password.")
                    }
                }
            })
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil)
    }

    func signIn() {
        UIApplication.appDelegate.switchToMainViewController()
    }

    @objc func signUpPressed() {
        let signUpVC = SignUpViewController.storyboardInstance as! SignUpViewController
        let navController = UINavigationController(rootViewController: signUpVC)
        navController.isNavigationBarHidden = true
        self.present(navController, animated: true, completion: nil)
    }

    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Snap", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK: Layout
extension LoginViewController: Layoutable {
    func layout() {
        view.addSubview(stackView)
        [emailTextField, passwordTextField, signInButton, signUpButton, forgotPassword].forEach { stackView.addArrangedSubview($0) }

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

        signInButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(40.0)
        }

        signUpButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(40.0)
        }

        forgotPassword.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(80)
            make.right.equalToSuperview().offset(-80)
        }
    }
}
