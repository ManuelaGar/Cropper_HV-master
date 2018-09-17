//
//  SeleccionarMedidaViewController.swift
//  Cropper
//
//  Created by Kiron on 9/17/18.
//  Copyright © 2018 Manuela Garcia. All rights reserved.
//

import UIKit

class SeleccionarMedidaViewController: UIViewController {
    
    var medida = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
//        let vc2 = segue.destination as! CropViewController
        vc.medida = self.medida
//        vc2.medida = self.medida
        
//        if segue.identifier == "showMedida" {
//            let MedidaViewController = segue.destination as! ViewController
//        }
    }
    
    @IBAction func medidaHorizontal(_ sender: UIButton) {
        // Si la medida es horizontal
        self.medida = 1
        self.performSegue(withIdentifier: "showMedida", sender: self)
    }
    
    @IBAction func medidaVertical(_ sender: UIButton) {
        // Si la medida es vertical
        self.medida = 2
        self.performSegue(withIdentifier: "showMedida", sender: self)
    }
}
