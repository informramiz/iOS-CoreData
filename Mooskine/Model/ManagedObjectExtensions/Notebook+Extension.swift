//
//  Notebook+Extension.swift
//  Mooskine
//
//  Created by Ramiz Raja on 28/08/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

extension Notebook {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
