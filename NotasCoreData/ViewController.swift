//
//  ViewController.swift
//  NotasCoreData
//
//  Created by Máster Móviles on 05/12/2019.
//  Copyright © 2019 Máster Móviles. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var fechaEtiqueta: UILabel!
    @IBOutlet weak var mensajeEtiqueta: UILabel!
    @IBOutlet weak var notaField: UITextView!
    @IBOutlet weak var picker: UIPickerView!
    
    let miGestorPicker = GestorPicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Aquí, "picker" es el outlet que representa al "picker view"
        //CAMBIALO por el nombre que le hayas dado
        self.picker.delegate = self.miGestorPicker
        self.picker.dataSource = self.miGestorPicker
        //cargamos las libretas con Core Data
        self.miGestorPicker.cargarLista()
    }

    @IBAction func nuevaNota(_ sender: Any) {
        fechaEtiqueta.text = ""
        mensajeEtiqueta.text = ""
        notaField.text = ""
    }
    @IBAction func guardarNota(_ sender: Any) {
        guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let miContexto = miDelegate.persistentContainer.viewContext
        
        let nuevaNota = Nota(context:miContexto)
        nuevaNota.fecha = Date()
        nuevaNota.texto = notaField.text!
        
        let numLibreta = self.picker.selectedRow(inComponent: 0)
        let libretas = self.miGestorPicker.libretas
        
        nuevaNota.libreta = libretas[numLibreta]
        
        do{
            try miContexto.save()
            
            notaField.text = nuevaNota.texto
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let now = df.string(from: Date())
            fechaEtiqueta.text = now
            mensajeEtiqueta.text = "nota guardada"
            
        }catch let error as NSError{
            if error.code==NSValidationStringTooShortError {
                print("Campo demasiado corto")
                mensajeEtiqueta.text = "Campo demasiado corto"
                
                miContexto.refresh(nuevaNota, mergeChanges: false)
            }
        }catch let error{
            print("Error al guardar el contexto: \(error)")
        }
        
    }
    
    @IBAction func nuevaLibreta(_ sender: Any) {
        let alert = UIAlertController(title: "Nueva libreta",
                                      message: "Escribe el nombre para la nueva libreta",
                                      preferredStyle: .alert)
        let crear = UIAlertAction(title: "Crear", style: .default) {
            action in
            let nombre = alert.textFields![0].text!
            //AQUI FALTA GUARDAR LA LIBRETA CON CORE DATA
            guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let miContexto = miDelegate.persistentContainer.viewContext
            let nuevaLibreta = Libreta(context:miContexto)
            nuevaLibreta.nombre = nombre
            
            self.miGestorPicker.libretas.append(nuevaLibreta)
            self.picker.reloadAllComponents()
            
            do{
                try miContexto.save()
            }catch let error{
                print("Error al guardar el contexto: \(error)")
            }

        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel) {
            action in
        }
        alert.addAction(crear)
        alert.addAction(cancelar)
        alert.addTextField() { $0.placeholder = "Nombre"}
        self.present(alert, animated: true)
    }
    
    
}

