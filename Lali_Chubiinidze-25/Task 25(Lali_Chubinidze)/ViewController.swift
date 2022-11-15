import UIKit

class ViewController: UIViewController {

    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var PreviewTableView: UITableView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var previewLabel: UILabel!

    let manager = FileManager.default
    var dirs: [String] = []
    var files: [String] = []
    var url: URL? = nil
    var folderName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfiguration()
        fillDirArr()
        previewConfiguration()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if textField.text != nil && textField.text != "" {
            var mUrl = manager.urls(for: .documentDirectory, in: .userDomainMask).first
            mUrl!.appendPathComponent(textField.text!)
            
            do {
                try manager.createDirectory( at: mUrl!, withIntermediateDirectories: true )
                dirs = []; fillDirArr()

            } catch { print(error) }
        } else { print("invalid dirName") }
    }

    func presentFilesVC(folder: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "FilesManagerVC") as! FilesManagerVC
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        vc.folderName = folder
        vc.config()
        present(vc, animated: true, completion: nil)
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.mainTableView
             { return dirs.count }
        else { return files.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.mainTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            let i = indexPath[1]
            cell.index = i
            cell.delegate = self
            cell.config()
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondTableViewCell", for: indexPath) as! secondTableViewCell
            let i = indexPath[1]
            cell.index = i
            cell.firstPageDelegate = self
            cell.config()
            cell.firstPage = true
            cell.url = self.url
            return cell
        }
    }
   
    func tableViewConfiguration() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        mainTableView.reloadData()
    }
    
    func previewConfiguration() {
        PreviewTableView.delegate = self
        PreviewTableView.dataSource = self
        PreviewTableView.register(UINib(nibName: "secondTableViewCell", bundle: nil), forCellReuseIdentifier: "secondTableViewCell")
        PreviewTableView.reloadData()
    }
    
    func fillDirArr() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let directoryContents = try FileManager.default.contentsOfDirectory( at: documentDirectory, includingPropertiesForKeys: nil )

            dirs = []
            for url in directoryContents {
                print(url.localizedName ?? url.lastPathComponent)
                dirs += [String(url.localizedName ?? url.lastPathComponent)]
            }
        } catch { print(error) }
        DispatchQueue.main.async { self.mainTableView.reloadData() }
    }
    
    func fillFilesArr() {
        if url != nil {
            do {
                let documentDirectory = url!
                let directoryContents = try FileManager.default.contentsOfDirectory( at: documentDirectory, includingPropertiesForKeys: nil )

                files = []
                for url in directoryContents {
                    print(url.localizedName ?? url.lastPathComponent)
                    files += [String(url.localizedName ?? url.lastPathComponent)]
                }
            } catch { print(error) }
            DispatchQueue.main.async { self.PreviewTableView.reloadData() }
        }
    }
}


