import UIKit

class MainTableViewController: UITableViewController, UITextFieldDelegate {
    
    var coordinates = Coordinates()
    var activeTextField: UITextField?

    
    let placeholderTexts = ["50.447165", "30.453952", "5593789", "6319300"]
    let numberLimit = 9 // Maximum number of characters allowed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "FieldCell")
        
        let numberField = UITextField()
        numberField.delegate = self
        numberField.keyboardType = .decimalPad
        numberField.placeholder = placeholderTexts[indexPath.section * 2 + indexPath.row]
        cell.contentView.addSubview(numberField)
        numberField.translatesAutoresizingMaskIntoConstraints = false
        numberField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16.0).isActive = true
        numberField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16.0).isActive = true
        numberField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
        numberField.tag = indexPath.section * 2 + indexPath.row

        
        return cell
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text {
            if let doubleValue = Double(text) {
                switch textField.tag {
                case 0:
                    coordinates.WGS84[0] = doubleValue
                    coordinates.WGS84_SK42()
                case 1:
                    coordinates.WGS84[1] = doubleValue
                    coordinates.WGS84_SK42()
                case 2:
                    coordinates.SK42[0] = doubleValue
                    coordinates.SK42_WGS84()
                case 3:
                    coordinates.SK42[1] = doubleValue
                    coordinates.SK42_WGS84()
                default:
                    print("loh")
                }
                printNumber()
            } else {
                // Handle the case where the text cannot be converted to a Double
            }
        } else {
            // Handle the case where textField.text is nil
        }
        
        // Clear CK-42 and WGS 84 cells if both WGS cells are empty
        let firstWgsCellIndexPath = IndexPath(row: 0, section: 0)
        let secondWgsCellIndexPath = IndexPath(row: 1, section: 0)
        let firstCk42CellIndexPath = IndexPath(row: 0, section: 1)
        let secondCk42CellIndexPath = IndexPath(row: 1, section: 1)
        
        guard let firstWgsCell = tableView.cellForRow(at: firstWgsCellIndexPath),
              let secondWgsCell = tableView.cellForRow(at: secondWgsCellIndexPath),
              let firstCk42Cell = tableView.cellForRow(at: firstCk42CellIndexPath),
              let secondCk42Cell = tableView.cellForRow(at: secondCk42CellIndexPath) else {
            return
        }
        
        let firstWgsNumberField = firstWgsCell.contentView.subviews.first as? UITextField
        let secondWgsNumberField = secondWgsCell.contentView.subviews.first as? UITextField
        let firstCk42NumberField = firstCk42Cell.contentView.subviews.first as? UITextField
        let secondCk42NumberField = secondCk42Cell.contentView.subviews.first as? UITextField
        
        if firstWgsNumberField?.text?.isEmpty == true && secondWgsNumberField?.text?.isEmpty == true {
            firstCk42NumberField?.text = ""
            secondCk42NumberField?.text = ""
        } else if firstCk42NumberField?.text?.isEmpty == true && secondCk42NumberField?.text?.isEmpty == true {
            firstWgsNumberField?.text = ""
            secondWgsNumberField?.text = ""
        }
    }
    
    func printNumber() {
        guard let textField = activeTextField else { return }
        let currentTag = textField.tag
        
        switch currentTag {
        case 0:
            guard let thirdCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) else { return }
            if let thirdNumberField = thirdCell.contentView.subviews.first as? UITextField {
                thirdNumberField.text = String(coordinates.SK42[0]) // Set the text of the third cell's text field to the first cell's text
            }
            
            guard let fourthCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) else { return }
            if let fourthNumberField = fourthCell.contentView.subviews.first as? UITextField {
                fourthNumberField.text = String(coordinates.SK42[1])
            }
            
        case 1:
            guard let thirdCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) else { return }
            if let thirdNumberField = thirdCell.contentView.subviews.first as? UITextField {
                thirdNumberField.text = String(coordinates.SK42[0]) // Set the text of the third cell's text field to the first cell's text
            }
            
            guard let fourthCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) else { return }
            if let fourthNumberField = fourthCell.contentView.subviews.first as? UITextField {
                fourthNumberField.text = String(coordinates.SK42[1])
            }
            
        case 2:
            guard let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) else { return }
            if let firstNumberField = firstCell.contentView.subviews.first as? UITextField {
                firstNumberField.text = String(coordinates.WGS84[0])
            }
            
            guard let secondCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) else { return }
            if let secondNumberField = secondCell.contentView.subviews.first as? UITextField {
                secondNumberField.text = String(coordinates.WGS84[1])
            }
            
        case 3:
            guard let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) else { return }
            if let firstNumberField = firstCell.contentView.subviews.first as? UITextField {
                firstNumberField.text = String(coordinates.WGS84[0])
            }
            
            guard let secondCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) else { return }
            if let secondNumberField = secondCell.contentView.subviews.first as? UITextField {
                secondNumberField.text = String(coordinates.WGS84[1])
            }
        default:
            print("Do nothing")
            print(currentTag)
        }
    }




    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            activeTextField = textField
            // Calculate the new text if the replacement string is applied
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Check if the updated text exceeds the limit
            if updatedText.count <= numberLimit {
                return true // Allow the change
            } else {
                return false // Reject the change
            }
        }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            let headerLabel = UILabel()
            headerLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            switch section {
            case 0:
                headerLabel.text = "WGS 84"
            case 1:
                headerLabel.text = "CK-42"
            default:
                headerLabel.text = ""
            }
            headerView.addSubview(headerLabel)
            headerLabel.translatesAutoresizingMaskIntoConstraints = false
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16.0).isActive = true
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
            return headerView
        }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func dismissKeyboard() {
        tableView.keyboardDismissMode = .interactive
        view.endEditing(true)
    }
}

