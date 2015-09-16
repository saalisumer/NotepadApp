//
//  NoteViewController.swift
//  NotePadApp
//
//  Created by SAALIS UMER on 06/09/15.
//  Copyright (c) 2015 SAALIS UMER. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate, UIPopoverControllerDelegate, NEOColorPickerViewControllerDelegate,KPFontPickerDelegate {
    let KEYBOARD_HEIGHT = 216
    @IBOutlet weak var txtViewNote : UITextView!
    @IBOutlet weak var bgIconsView: UIView!

    var note: Note? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func pickerDidSelectFont(font: String!, withSize fontSize: CGFloat, color fontColor: UIColor!) {
        self.txtViewNote.font = UIFont(name: font, size: fontSize)
        self.txtViewNote.textColor = fontColor
        self.txtViewNote .setNeedsDisplay()
        
        self.note?.attribute.font = font
        self.note?.attribute.size = Int16(fontSize)
        self.note?.attribute.textColor = fontColor.toHexString()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.saveContext()
    }

    func configureView() {
        // Update the user interface for the detail item.
        
        if let noteObject: Note = self.note {
            if let textView = self.txtViewNote {
                textView.text = noteObject.message
                textView.delegate = self
                if let colorHex = note?.attribute.bgColor
                {
                    textView.backgroundColor = UIColor(hexString:colorHex)
                }
                else
                {
                    textView.backgroundColor = UIColor.whiteColor()
                }
                textView.contentMode = .Redraw
                if let fontName = note?.attribute.font
                {
                    if let fontSize = note?.attribute.size
                    {
                        self.txtViewNote.font = UIFont(name: fontName, size: CGFloat(fontSize))
                    }
                    else
                    {
                        self.txtViewNote.font = UIFont(name: fontName, size: 12.0)
                    }
                }
                else
                {
                    if let fontSize = note?.attribute.size
                    {
                        self.txtViewNote.font = UIFont(name: "Marion-Regular", size: CGFloat(fontSize))
                    }
                    else
                    {
                        self.txtViewNote.font = UIFont(name: "Marion-Regular", size: 12.0)
                    }
                }
                
                if let textColor = self.note?.attribute.textColor
                {
                    self.txtViewNote.textColor = UIColor(hexString:textColor)
                }
                else
                {
                    self.txtViewNote.textColor = UIColor.blackColor()
                }
            }
        }
        

    }
    
    func loadFontPicker()
    {
        // Custom list of font. By default it loads all the fonts in the system.
        var fonts = [NSString]()
        fonts.append("AmericanTypewriter")
        fonts.append("Baskerville")
        fonts.append("Copperplate")
        fonts.append("Didot")
        fonts.append("EuphemiaUCAS")
        fonts.append("Futura-Medium")
        fonts.append("GillSans")
        fonts.append("Helvetica")
        fonts.append("Marion-Regular")
        fonts.append("Optima-Regular")
        fonts.append("Palatino-Roman")
        fonts.append("TimesNewRoman")
        fonts.append("Verdana")
        
        self.picker = KPFontPicker(fonts: fonts)
        self.picker.delegate = self
        self.txtViewNote.inputAccessoryView = self.createToolbar()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false; //
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        self.loadFontPicker()
        self.validateVisibility()
    }
    
    func validateVisibility()
    {
        if let noteObj = note
        {
            self.bgIconsView.hidden = false
            self.txtViewNote.hidden = false
        }
        else
        {
            self.bgIconsView.hidden = true
            self.txtViewNote.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSelectedColor(color: UIColor!) {
        self.txtViewNote.backgroundColor = color;
    }
    
    @IBAction func didTapBackground(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func didTapCut(sender: AnyObject) {
        let range = self.txtViewNote.selectedRange
        let substring = self.txtViewNote.text .substringWithRange(self.StringRangeToRange(self.txtViewNote.text, range: range))
        ClipboardUtility.copyText(substring)
        self.txtViewNote.replaceRange(self.txtViewNote.selectedTextRange!, withText: "")        
    }
    
    func StringRangeToRange(text: String, range: NSRange) -> Range<String.Index> {
        let start = advance(text.startIndex, range.location)
        let end = advance(start, range.length)
        let swiftRange = Range<String.Index>(start: start, end: end)
        return swiftRange
    }
    
    @IBAction func didTapCopy(sender: AnyObject) {
        let range = self.txtViewNote.selectedRange
        let substring = self.txtViewNote.text .substringWithRange(self.StringRangeToRange(self.txtViewNote.text, range: range))
        ClipboardUtility.copyText(substring)
    }

    @IBAction func didTapPaste(sender: AnyObject) {
        let range = self.txtViewNote.selectedRange
        self.txtViewNote.replaceRange(self.txtViewNote.selectedTextRange!, withText: ClipboardUtility.getClipboardTest())
    }
    
    var popover:UIPopoverController?
    
    @IBAction func didTapChangeBackgroundColor(sender: AnyObject) {
        
        var controller : NEOColorPickerHSLViewController  = NEOColorPickerHSLViewController()
        controller.delegate = self
        if let bgColor = self.note?.attribute.bgColor
        {
            controller.selectedColor = UIColor(hexString: note!.attribute.bgColor)
        }
        else
        {
            controller.selectedColor = UIColor.whiteColor()
        }
        controller.title = "Pick Background Color"
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad
        {
            popover = UIPopoverController(contentViewController: controller)
            popover?.presentPopoverFromRect(sender.superview!!.convertRect(sender.frame, toView: self.view), inView: self.view, permittedArrowDirections:.Up, animated: true)
        }
        else
        {
            self.presentViewController(controller, animated: true) { () -> Void in
                
            }
        }

    }
    
    @IBAction func didTapChangeFont(sender: AnyObject) {
        self.txtViewNote.becomeFirstResponder()
        self.pickerClicked(self.txtViewNote)
    }
    
// UITextView Delegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var text1:NSString = self.txtViewNote.text as NSString
        text1 = text1 .stringByReplacingCharactersInRange(range, withString: text)
        note?.message = text1 as String
        note?.timeStampModified = NSDate().timeIntervalSince1970
        
        appDelegate.saveContext()
        return true;
    }
    
    //NeoColorPickerViewControllerDelegate Methods
    func colorPickerViewController(controller:NEOColorPickerBaseViewController, didSelectColor color:UIColor)
    {
        self.txtViewNote.backgroundColor = color
        note?.attribute.bgColor = color.toHexString()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad
        {
            popover?.dismissPopoverAnimated(true)
        }
        else
        {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
        }
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.saveContext()
    }
    
    func colorPickerViewControllerDidCancel(controller :NEOColorPickerBaseViewController)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func colorPickerViewController(controller:NEOColorPickerBaseViewController, didChangeColor color:UIColor)
    {
    
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        self.txtViewNote.setNeedsDisplay()
    }
    
    
    var picker : KPFontPicker!
    
    func createToolbar()->UIToolbar
    {
        var keyboardDoneButtonView : UIToolbar = UIToolbar()
    keyboardDoneButtonView.barTintColor = UIColor.darkGrayColor()
    keyboardDoneButtonView.tintColor = UIColor.whiteColor()
    keyboardDoneButtonView.sizeToFit()
        
        var keyboardButton:UIBarButtonItem = UIBarButtonItem(title: "Keyboard", style: UIBarButtonItemStyle.Plain , target: self, action: Selector("keyboardClicked:"))
        
        var fontButton:UIBarButtonItem = UIBarButtonItem(title: "Font", style: UIBarButtonItemStyle.Plain , target: self, action: Selector("pickerClicked:"))
 
        var flex:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)

        var doneButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("doneClicked:"))

        var buttons = [UIBarButtonItem]()
        buttons.append(keyboardButton)
        buttons.append(fontButton)
        buttons.append(flex)
        buttons.append(doneButton)
        keyboardDoneButtonView.setItems(buttons, animated: true)
        return keyboardDoneButtonView
    }
    
    func keyboardClicked(sender:AnyObject)
    {
        if (self.txtViewNote.isFirstResponder()) {
            self.txtViewNote.inputView = nil
            self.txtViewNote.reloadInputViews()
        }
    }
    
    func pickerClicked(sender:AnyObject)
    {
        if let fontName = note?.attribute.font
        {
            if let fontSize = note?.attribute.size
            {
                self.picker.font = UIFont(name: fontName, size: CGFloat(fontSize))
            }
            else
            {
                self.picker.font = UIFont(name: fontName, size: 12.0)
            }
        }
        else
        {
            if let fontSize = note?.attribute.size
            {
                self.picker.font = UIFont(name: "Marion-Regular", size: CGFloat(fontSize))
            }
            else
            {
                self.picker.font = UIFont(name: "Marion-Regular", size: 12.0)
            }
        }
        
        if let textColor = self.note?.attribute.textColor
        {
            self.picker.color = UIColor(hexString:textColor)
        }
        else
        {
            self.picker.color = UIColor.blackColor()
        }

        
        if (self.txtViewNote.isFirstResponder()) {
        self.txtViewNote.inputView = self.picker
        self.txtViewNote.reloadInputViews()
    }
    }
    
    func doneClicked(sender: AnyObject)
    {
        if (self.txtViewNote.isFirstResponder()) {
            self.txtViewNote.inputView = nil
            self.txtViewNote.resignFirstResponder()
    }
    }

    

}


