//
//  ViewController.swift
//  happy_faces
//
//  Created by Arati Bam on 12/03/19.
//  Copyright © 2019 Manas Bam. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
   
    let model=happy_faces()
    @IBOutlet weak var myImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func takePhoto(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            let imagePicker=UIImagePickerController()
            imagePicker.delegate=self
            imagePicker.sourceType=UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing=false
            self.present(imagePicker,animated: true, completion: nil)
        }
        else{
            print("NO")
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage=info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            myImage.contentMode = .scaleToFill
            myImage.image=pickedImage
            myImage.image=image(with: myImage.image!, scaledTo: CGSize(width: 48.0, height: 48.0))
            let k=convertImageToBW(image: myImage.image!)
            let output = try? model.prediction(image:k as! CVPixelBuffer)
            print(output!)
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func image(with image: UIImage, scaledTo newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
    
    func convertImageToBW(image:UIImage) -> UIImage {
        
        let filter = CIFilter(name: "CIPhotoEffectMono")
        
        // convert UIImage to CIImage and set as input
        
        let ciInput = CIImage(image: image)
        filter?.setValue(ciInput, forKey: "inputImage")
        
        // get output CIImage, render as CGImage first to retain proper UIImage scale
        
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        
        return UIImage(cgImage: cgImage!)
    }
    
    
    
    
    
}




