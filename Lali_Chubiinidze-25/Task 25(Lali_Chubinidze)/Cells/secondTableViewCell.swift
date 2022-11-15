import UIKit

class secondTableViewCell: UITableViewCell {
    
    var index: Int? = nil
    var fileName = ""
    var firstPage = false
    weak var delegate: FilesManagerVC? = nil
    weak var firstPageDelegate: ViewController? = nil
    var url: URL? = nil
    
    @IBOutlet var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config() {
        if index != nil && delegate != nil {
            fileName = delegate!.arrayOfFiles[index!]
            name.text = fileName
        } else {
            if index != nil && firstPageDelegate != nil {
                fileName = firstPageDelegate!.files[index!]
                name.text = fileName
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if firstPage && firstPageDelegate != nil {
            let fileUrl = self.url!.appendingPathComponent(self.fileName)
            var content = ""
            
            do { content = try String(contentsOf: fileUrl, encoding: .utf8) } catch { print(error) }
            let ac = UIAlertController(title: fileName, message: content, preferredStyle: .alert)
            ac.addTextField()
            let submitAction = UIAlertAction(title: "Edit and Save", style: .default) { [unowned ac] _ in
                let answer = ac.textFields![0].text ?? ""
                do { try answer.write(to: fileUrl, atomically: false, encoding: .utf8) } catch { print(error) }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            ac.addAction(submitAction)
            ac.addAction(cancelAction)
            firstPageDelegate!.present(ac, animated: true)
        } else {
            if delegate != nil && fileName != "" {
                delegate!.chosenFile = fileName

            }
        }
    }
}
