import UIKit

class FilesManagerVC: UIViewController {
    
    @IBOutlet var textField: UITextField!

    var folderName = ""
    var chosenFile = ""
    var arrayOfFiles: [String] = []
    weak var delegate: ViewController? = nil
    let manager = FileManager.default
    var url: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func config() { url = manager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(folderName) }

    @IBAction func createButton(_ sender: Any) {
        if textField.text != nil && textField.text != "" && delegate != nil{
            let ac = UIAlertController(title: textField.text!, message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            let submitAction = UIAlertAction(title: "Save", style: .default) { [unowned ac] _ in
                let answer = ac.textFields![0].text ?? ""
                var fileUrl = self.url!.appendingPathComponent(self.textField.text!)
                fileUrl.appendPathExtension("text")
                let textData = answer.data(using: .utf8)!
                self.manager.createFile(atPath: fileUrl.path, contents: textData, attributes: nil)
                self.textField.text = ""
                //self.fillFilesArr()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            ac.addAction(submitAction)
            ac.addAction(cancelAction)
            present(ac, animated: true)
        }
    }
    @IBAction func `return` (_ sender: Any) { self.dismiss(animated: true, completion: nil) }
}

extension FilesManagerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfFiles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "secondTableViewCell", for: indexPath) as! secondTableViewCell
        let i = indexPath[1]
        cell.index = i
        cell.delegate = self
        cell.config()
        return cell
    }
}
