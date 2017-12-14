//
//  ViewController.swift
//  TouchId
//
//  Created by Skander Jabouzi on 2017-12-14.
//  Copyright © 2017 Skander Jabouzi. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }

    @IBAction func buttonClicked(_ sender: Any) {
        var error: NSError?
        
        let authenticationContext = LAContext()
        
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
        }
        
        authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "TouchID Login ...", reply: {
            (sucess, error) -> () in
                
            if( sucess ) {
                
                self.navigateToAuthenticatedViewController()
                
            }else {
                
                if let error = error {
                    
                    let message = self.errorMessageForLAErrorCode(error._code)
                    self.showAlertViewAfterEvaluatingPolicyWithMessage(message)
                    
                }
                
            }

        })
    }
    
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        
        showAlertWithTitle(title: "Error", message: "This device does not have a TouchID sensor.")
        
    }
    
    func showAlertViewAfterEvaluatingPolicyWithMessage( _ message:String ){
        showAlertWithTitle(title: "Error", message: message)
    }
    
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async() { () -> Void in
            self.present(alertVC, animated: true, completion: nil)
        }        
    }
    
    func errorMessageForLAErrorCode( _ errorCode:Int ) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case LAError.Code.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.Code.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.Code.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.Code.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.Code.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.Code.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.Code.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.Code.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.Code.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        return message
    }

    
    func navigateToAuthenticatedViewController(){
        if let loggedInVC = storyboard?.instantiateViewController(withIdentifier: "ProtectedContentViewController") {
            DispatchQueue.main.async { () -> Void in
                self.navigationController?.pushViewController(loggedInVC, animated: true)
            }
        }
    }

    
}

