//
//  ViewController.swift
//  CSVDEMO
//
//  Created by vsoft on 26/08/19.
//  Copyright © 2019 com.vsoftcorp.arya. All rights reserved.
//

import UIKit
import MobileCoreServices
struct FileImportReqStruct : Codable{
    var accountNo : String?
    var checkNo : String?
    var Payeename : String?
    var amount : String?
    var issueDate : String?
    var trasnsactionIndicator:String?
}

class ViewController: UIViewController ,UIDocumentPickerDelegate,UINavigationControllerDelegate{
    var document: UIDocument?

//    let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
    
      let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeCommaSeparatedText)], in: .import)
    var data : Data = Data()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    func readCSVFile(){
        do {
            // From a file (with errors)
            let csvFile: CSV = try CSV(url: URL(fileURLWithPath: "path/to/users.csv"))
            
            // From a file inside the app bundle, with a custom delimiter, errors, and custom encoding
            let resource: CSV? = try CSV(
                name: "users",
                extension: "tsv",
                bundle: .main,
                delimiter: "\t",
                encoding: .utf8)
        } catch let parseError as CSVParseError {
            // Catch errors from parsing invalid formed CSV
        } catch {
            // Catch errors from trying to load files
        }
        
    }
    
    @IBAction func onFileSelect(_ sender : UIButton){
        self.documentPicker.delegate = self
        self.present(self.documentPicker, animated: true)
        
        
        
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls.first?.absoluteURL)
        print(urls.first?.path)
        
        self.handleFileSelection(inUrl: urls.first!)
        
        self.dismiss(animated: true, completion: nil)
        
        
        let typeSTR = self.mimeTypeForPath(path: "\(urls.first!)")
        print(typeSTR)
        
        
    }
    
    func mimeTypeForPath(path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    func handleFileSelection(inUrl:URL) -> Void {
        do {
            self.data = try Data(contentsOf: inUrl)
            let typeSTR = self.mimeTypeForPath(path: "\(inUrl)")
            print(typeSTR)
            do {
                

                let urlString: String = inUrl.path
                let csvFile: CSV = try CSV(url: URL(fileURLWithPath: urlString))
                print(csvFile)
                
                for onerow  in csvFile.enumeratedRows{
                    print(onerow)
                     print(onerow.count)
                    for oneitem in onerow{
                        print(oneitem)
                       
                        
                    }
                    
                    
                    
                }

                

            

            } catch let parseError as CSVParseError {
                print(parseError.localizedDescription)
                // Catch errors from parsing invalid formed CSV
            } catch {
                // Catch errors from trying to load files
            }
            

            


        } catch let error {
            print(error)
            
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }

}
