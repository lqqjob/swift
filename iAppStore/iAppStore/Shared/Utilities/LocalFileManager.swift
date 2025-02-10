//
//  LocalFileManager.swift
//  iAppStore
//
//  Created by liqiang on 2025/2/10.
//

import Foundation
import SwiftUI

class LocalFileManager {
    static let instance = LocalFileManager()
    private init() {}
    
    func saveImage(image:UIImage,imageName:String,folderName:String) {
        createFolderIfNeeded(folderName: folderName)
        
        guard let data = image.pngData(),
              let url = getURLForImage(imageName: imageName, folderName: folderName) else {
            return
        }
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. ImageName: \(imageName) \(error)")
        }
        
    }
    
    func getImage(imageName:String,folderName:String) -> UIImage? {
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName:String) {
        guard let url = getURLForFolder(folderName: folderName) else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. FolderName: \(folderName). \(error)")

            }
        }
    }
    
    private func getURLForFolder(folderName:String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,folderName.isNotEmpty else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName:String,folderName:String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName),imageName.isNotEmpty else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName + ".png");
    }
}
