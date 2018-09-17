//
//  ViewController.swift
//  Cropper
//
//  Created by Manuela Garcia on 6/08/18.
//  Copyright © 2018 Manuela Garcia. All rights reserved.
//

import UIKit
import IGRPhotoTweaks

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageMeasure: UIImageView!
    
    @IBOutlet weak var editItem: UIBarButtonItem!
    @IBOutlet weak var libraryItem: UIBarButtonItem!
    
    @IBOutlet weak var medidaLabel: UILabel!
    fileprivate var image: UIImage!
    
    var imageWasTapped = false
    var medida = 0
    var tap = 0
    var mmX: Float = 0
    var mmY: Float = 0
    var altura: Float = 0
    let pickerView = UIImagePickerController.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.allowsEditing = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mmEnImagenCortada()
        if (self.image == nil) {
            openLibrary()
            self.medidaLabel?.text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc1 = segue.destination as! CropViewController
        vc1.tap1 = self.tap
        vc1.medida = self.medida
        
        if segue.identifier == "showCrop" {
            let exampleCropViewController = segue.destination as! CropViewController
            exampleCropViewController.image = sender as! UIImage
            exampleCropViewController.delegate = self
        }
    }
    
    // MARK: - Funcs
    
    @objc func openLibrary() {
        pickerView.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(pickerView, animated: true, completion: nil)
    }
    
    
    @IBAction func openCameraPressed(_ sender: UIBarButtonItem) {
        pickerView.sourceType = UIImagePickerControllerSourceType.camera
        self.present(pickerView, animated: true, completion: nil)
    }
    
    @IBAction func openLibraryPressed(_ sender: UIBarButtonItem) {
        pickerView.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(pickerView, animated: true, completion: nil)
    }
    
    func edit(image: UIImage) {
        self.performSegue(withIdentifier: "showCrop", sender: image)
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        self.edit(image: self.image)
    }
    
    @IBAction func imageClicked(_ sender: Any){
        print("image tapped \(imageWasTapped)")
        imageWasTapped = true
        self.tap = 1
        edit(image: image)
    }
    
    @objc func mmEnImagenCortada(){
        self.mmX = UserDefaults.standard.float(forKey: "mmEnX")
        self.mmY = UserDefaults.standard.float(forKey: "mmEnY")
        self.altura = UserDefaults.standard.float(forKey: "altura")
        
        if (self.medida == 1) {
            self.medidaLabel?.text = "mmX: \(self.mmX), mmY: \(self.mmY)"
        }
        if (self.medida == 2) {
            self.medidaLabel?.text = "h: \(self.altura)"
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.image = image
        let imageSize1 = image.size
        let imageWidth: CGFloat = image.size.width
        let imageHeight: CGFloat = image.size.height
        
        print("Original Image")
        print(imageSize1)
        print(imageWidth)
        print(imageHeight)
        
        picker.dismiss(animated: true) {
            self.edit(image: image)
        }
    }
}

extension ViewController: IGRPhotoTweakViewControllerDelegate {
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage) {
        if self.tap == 1 {
            self.tap = 0
            imageWasTapped = false
            self.imageMeasure?.image = croppedImage
            let croppedWidth: CGFloat = croppedImage.size.width
            let croppedHeight: CGFloat = croppedImage.size.height
            let aspect = croppedHeight/croppedWidth
            UserDefaults.standard.set(aspect, forKey: "aspect")
            print("Aspect \(aspect) y \(UserDefaults.standard.float(forKey: "aspect"))")
        } else {
            self.imageView?.image = croppedImage
        }
        _ = controller.navigationController?.popViewController(animated: true)
    }
    
    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController) {
        _ = controller.navigationController?.popViewController(animated: true)
    }
}
