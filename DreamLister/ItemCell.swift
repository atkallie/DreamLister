//
//  ItemCell.swift
//  DreamLister
//
//  Created by Ahmed T Khalil on 2/7/17.
//  Copyright © 2017 kalikans. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var itemPrice: UILabel!
    @IBOutlet var itemDetails: UILabel!
    
    
    func configureCell(_ item:Item){
        itemTitle.text = item.title
        itemPrice.text = "$\(item.price)0"
        itemDetails.text = item.details
        //if there is something saved, display it; otherwise, use the default icon
        if let image = item.toPicture?.image as? UIImage{
            itemImage.image = image
        }
    }
    
    //Boiler Plate Code
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
