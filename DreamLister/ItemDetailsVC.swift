//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Ahmed T Khalil on 2/7/17.
//  Copyright © 2017 kalikans. All rights reserved.
//

import UIKit

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var itemNameText: UITextField!
    @IBOutlet var itemPriceText: UITextField!
    @IBOutlet var itemDetailsText: UITextField!
    @IBOutlet var storePicker: UITextField!
    let picker = UIPickerView()
    
    //picker view data source
    var stores = [Store]()
    
/*********************  PICKER VIEW SETUP  **********************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //to remove back bar title
        self.navigationController?.navigationBar.topItem?.title = ""
        
        //link text field to picker view
        picker.delegate = self
        picker.dataSource = self
        storePicker.inputView = picker
        
        //6 sample stores already loaded into Core Data
        do{
            stores = try context.fetch(Store.fetchRequest())
        }catch{
            print("\(error)")
        }
        
        //If we're editing, load the data
        if itemToEdit != nil{
            itemNameText.text = itemToEdit?.title
            itemPriceText.text = "\((itemToEdit?.price)!)0"
            itemDetailsText.text = itemToEdit?.details
            storePicker.text = itemToEdit?.toStore?.name
            imageSelected.image = itemToEdit?.toPicture?.image as! UIImage?
        }
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stores[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        storePicker.text = stores[row].name
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

/*************** SAVE NEW ITEM/EDIT OLD ITEM **********************/
    var itemToEdit:Item?
    var item:Item!
    
    @IBAction func saveItem(_ sender: Any) {
        //Creating a new entry or saving?
        if itemToEdit == nil{
            item = Item(context: context)
        }else{
            item = itemToEdit
        }
        
        if let price = Double(itemPriceText.text!){
            item.price = price
            if itemNameText.text?.replacingOccurrences(of: " ", with: "") != nil{
                item.title = itemNameText.text
                item.details = itemDetailsText.text
                
                //use the relationship to store the store...punny
                item.toStore = stores[picker.selectedRow(inComponent: 0)]
                
                //use the relationship to store the selected image
                //note that we need to make the Picture object first and then associate the object to our item
                let picture = Picture(context: context)
                picture.image = imageSelected.image
                item.toPicture = picture
                
                do{
                    try context.save()
                }catch{
                    print("\(error)")
                }
                
                //pops the top view from the navigation stack
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
/*************** DELETING ENTRIES VIA TRASH CAN ************/
    @IBAction func trashButton(_ sender: Any) {
        if let itemToDelete = itemToEdit{
            context.delete(itemToDelete)
            do{
                try context.save()
                navigationController?.popViewController(animated: true)
            }catch{
                print("Maybe next time, chief. You got this error: \(error)")
            }
        }
    }

/*************** SELECTING AN IMAGE FOR AN ITEM **********************/
    
    @IBOutlet var imageSelected: UIImageView!
    let imagePicker = UIImagePickerController()
    
    //bring up photolibrary
    @IBAction func addImage(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //if user cancels without picking image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //set the selected image as
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageSelected.image = image
            
            //need a completion...I think
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
