//
//  AddShiftAssignmentsCollectionViewCell.swift
//  J4ShiftTable
//
//  Created by JHLin on 2017/5/22.
//  Copyright © 2017年 JHL. All rights reserved.
//

import UIKit

class AddShiftAssignmentsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel! {
        didSet {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = UIColor.black.cgColor
        }
    }
}
