//
//  Nota.swift
//  NotasCoreData
//
//  Created by Máster Móviles on 09/12/2019.
//  Copyright © 2019 Máster Móviles. All rights reserved.
//

//Archivo Nota+Custom.swift
import Foundation

extension Nota {
    //Devuelve una subcadena solo con la primera letra del texto
    @objc var inicial: String? {
        if let textoNoNil = self.texto {
            let pos2 = textoNoNil.index(after: textoNoNil.startIndex)
            return textoNoNil.substring(to:pos2)
        }
        else {
            return nil
        }
    }
}
