//
//  tableSizeViewController.swift
//  SnapHole
//
//  Created by Thomas Devisscher on 2017-07-23.
//  Copyright © 2017 Thomas Devisscher. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

struct cellData {
    let cell:  Int!
    let text:  String!
    let detailText: String!
    let image: UIImage!
    let bg_color: UIColor!
}



class tableSizeViewController: UITableViewController {
    var uuid = String()
    let cellColors = [UIColor(red:0.97, green:0.91, blue:0.11, alpha:1.0),UIColor(red:0.41, green:0.93, blue:0.53, alpha:1.0),UIColor(red:0.24, green:0.86, blue:0.95, alpha:1.0)] as [Any]
    let API_ENDPOINT = "https://ott311.esdev.xyz"
    var arrayOfCellData = [cellData]()
    
    override func viewDidLoad() {
        arrayOfCellData = [
            
            cellData(cell:1, text:"L", detailText:"This is a large pothole", image: #imageLiteral(resourceName: "L"), bg_color:UIColor(red:0.97, green:0.91, blue:0.11, alpha:1.0)),
            cellData(cell:2, text:"M",detailText:"This is a medium pothole", image: #imageLiteral(resourceName: "M"), bg_color:UIColor(red:0.41, green:0.93, blue:0.53, alpha:1.0)),
            cellData(cell:3, text:"S", detailText:"This is a small pothole", image: #imageLiteral(resourceName: "S"), bg_color:UIColor(red:0.24, green:0.86, blue:0.95, alpha:1.0))
        ]
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.orange
//        let image = UIImage()
//        image.frame = CGRect(x: 5, y:5, width: 35, height: 35)
        
        let label = UILabel()
        label.text = "How big is the pothole?"
        label.frame = CGRect(x: 45, y: 15, width: 250, height: 55)
        view.addSubview(label)

        return view

    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
            cell.mainImageView.image = arrayOfCellData[indexPath.row].image
            cell.mainLabel.text = arrayOfCellData[indexPath.row].text
            cell.detailLabel.text = arrayOfCellData[indexPath.row].detailText
            cell.contentView.backgroundColor = arrayOfCellData[indexPath.row].bg_color
        //[indexPath.row % cellColors.count]
            return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   
            return UITableViewAutomaticDimension
        }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
        if indexPath.row == 0 {
            self.specifySize(size: "large")
        } else if indexPath.row == 1 {
            self.specifySize(size: "medium")
        } else {
            self.specifySize(size: "small")
        }
        self.performSegue(withIdentifier: "toDetailView", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController: DetailsViewController = segue.destination as! DetailsViewController
        DestViewController.uuid = uuid
    }
    
    func specifySize(size: String){
        let parameters = ["uuid": self.uuid, "size": size] as [String : Any]
        Alamofire.request("\(API_ENDPOINT)/size", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseString { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
                }
                print(response)
                
        }
    }

    
}
