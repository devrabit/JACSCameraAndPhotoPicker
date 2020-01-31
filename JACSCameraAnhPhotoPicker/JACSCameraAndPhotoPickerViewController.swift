//
//  JACSCameraAndPhotoPickerViewController.swift
//  JACSCameraAnhPhotoPicker
//
//  Created by iMac on 1/31/20.
//  Copyright © 2020 Wigilabs. All rights reserved.
//

import UIKit

class JACSCameraAndPhotoPickerViewController: UIViewController {

    var susses: ((_ base: String,_ img:UIImage) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
   
    static func instantiate() -> ViewController {
        let storyboard = UIStoryboard(name: "", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! ViewController
        return vc
    }
    
    

    @IBAction func openCamera(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = false
        vc.delegate = self
        present(vc, animated: true)
    }
    @IBAction func openGallery(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            let vc = UIImagePickerController()
            vc.sourceType = .savedPhotosAlbum
            vc.allowsEditing = false
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
        }
    }
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    static func open(navController:UINavigationController, callback:@escaping(String,UIImage)->()) {
        let storyboard = UIStoryboard(name: "JACSCameraAndPhotoPicker", bundle: Bundle.main)
        
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! JACSCameraAndPhotoPickerViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        //vc.navigatioVC=navController
        vc.susses={(base:String,img:UIImage) -> Void in
            
            callback(base,img)
        }
        navController.present(vc, animated: true, completion: nil)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension JACSCameraAndPhotoPickerViewController:UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        //let strBase64 =  "data:image/jpg;base64,\(imageData!.base64EncodedString())"
        let strBase64 =  "\(imageData!.base64EncodedString())"
        self.dismiss(animated: true) {
            self.susses!(strBase64,image)
        }
        
        // print out the image size as a test
        print(image.size)
    }
    
    /*func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
     self.dismiss(animated: true, completion: { () -> Void in
     let imageData = image.jpegData(compressionQuality: 0.2)
     
     //let strBase64 =  "data:image/jpg;base64,\(imageData!.base64EncodedString())"
     let strBase64 =  "\(imageData!.base64EncodedString())"
     self.dismiss(animated: true) {
     self.susses!(strBase64,image)
     }
     })
     }*/
    
}
extension JACSCameraAndPhotoPickerViewController:UINavigationControllerDelegate{
    
}
extension UIViewController{
    func JACSopen(susses:@escaping (String,UIImage)->()){
        if let nC=self.navigationController{
            JACSCameraAndPhotoPickerViewController.open(navController: nC) { (base64, image) in
                susses(base64, image)
            }
        }else{
            let nC = UINavigationController(rootViewController: JACSCameraAndPhotoPickerViewController.instantiate())
            JACSCameraAndPhotoPickerViewController.open(navController: nC) { (base64, image) in
                susses(base64, image)
            }
        }
        
    }
}
