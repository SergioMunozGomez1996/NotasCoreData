//
//  GestorPicker.swift
//  NotasCoreData
//
//  Created by Máster Móviles on 05/12/2019.
//  Copyright © 2019 Máster Móviles. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class GestorPicker : NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var libretas = [Libreta]()

    //devuelve el número de columnas del picker. En nuestro caso solo 1
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    //devuelve el número de filas del picker (== número de libretas)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.libretas.count
    }

    //devuelve el título de una fila determinada
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.libretas[row].nombre
    }

    //para cargar la lista de libretas desde Core Data
    func cargarLista() {
        let miDelegate = UIApplication.shared.delegate as! AppDelegate
        let miContexto = miDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Libreta>(entityName:"Libreta")
        self.libretas = try! miContexto.fetch(request)
    }
}
