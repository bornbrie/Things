//
//  AttributesViewController+UITableView.swift
//  Things
//
//  Created by Brianna Lee on 7/18/16.
//  Copyright © 2016 Exoteric Design. All rights reserved.
//

import UIKit

extension AttributesViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableView Delegate / Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let thing = self.thing else {
            return 0
        }
        
        return thing.attributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let thing = self.thing else {
            fatalError()
        }
        
        let attribute = thing.attributes[indexPath.row]
        
        switch attribute.type {
            
        case .image:
            guard let imageAttribute = attribute as? ImageAttribute else { fatalError() }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellKey.attributeImage) as? ImageAttributeCell else { fatalError() }
            
            cell.thingImageView.image = imageAttribute.image
            
            cell.thingImageView.layer.borderColor = UIColor.darkGray.cgColor
            cell.thingImageView.layer.borderWidth = 1
            cell.imageProgressView.isHidden = true
            cell.thingDescriptionLabel.text = imageAttribute.created
            
            return cell
            
        case .text:
            guard let textAttribute = attribute as? TextAttribute else { fatalError() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellKey.attributeText) as! AttributeTextCell
            
            cell.newAttributeTextView.delegate = self
            cell.newAttributeTextView.text = textAttribute.text
            cell.thingDescriptionLabel.text = textAttribute.created ?? Date().string
            
            return cell
        }
    }
    
    private func rowHeight(for indexPath: IndexPath) -> CGFloat {
        guard let thing = self.thing else {
            fatalError()
        }
        
        let attribute = thing.attributes[indexPath.row]
        
        guard let imageAttribute = attribute as? ImageAttribute else {
            return UITableViewAutomaticDimension
        }
        
        guard let height = imageAttribute.imageHeight(from: tableView.frame.width) else {
            return UITableViewAutomaticDimension
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let thing = self.thing else {
            return nil
        }
        
        guard let header = (tableView.dequeueReusableCell(withIdentifier: "ThingTitleCell") as? ThingTitleCell) else {
            fatalError()
        }
        
        header.titleLabel.text = thing.name
        
        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = tableView.headerView(forSection: section) else {
            return 64
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteRowAction = UITableViewRowAction(style: .default, title: "Delete") { (action, actionIndexPath) in
            let alert = UIAlertController(title: "Are you sure you want to delete this Attribute?", message: "This cannot be undone!", preferredStyle: .alert)
            let yes = UIAlertAction(title: "🐍 YASssssss", style: .destructive) { action in
                self.deleteAttribute(at: indexPath)
            }
            let no = UIAlertAction(title: "No Keep it! 😰", style: .cancel, handler: nil)
            alert.addAction(yes)
            alert.addAction(no)
            self.present(alert, animated: true, completion: nil)
        }
        
        return [deleteRowAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let thing = self.thing else {
            fatalError()
        }
        
        let attribute = thing.attributes[indexPath.row]
        
        switch attribute.type {
        case .image:
            guard let imageAttribute = attribute as? ImageAttribute else {
                return
            }
            
            guard let image = imageAttribute.image else {
//                print("Image in attribute is nil????")
                return
            }
            
            performSegue(withIdentifier: "ImageSegue", sender: image)
            
        default:
            break
        }
    }
}
