//
//  PhotoPickerController+PHPhotoLibrary.swift
//  HXPhotoPicker
//
//  Created by Slience on 2021/8/25.
//

import UIKit
import Photos

// MARK: PHPhotoLibraryChangeObserver
extension PhotoPickerController: PHPhotoLibraryChangeObserver {
    
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        
    }
    
    private func resultHasChanges(
        for changeInstance: PHChange,
        assetCollection: PhotoAssetCollection
    ) -> Bool {
        guard let result = assetCollection.result else {
            if assetCollection == self.fetchData.cameraAssetCollection {
                return true
            }
            return false
        }
        if let changeResult  = changeInstance.changeDetails(for: result) {
            if changeResult.hasIncrementalChanges {
                if changeResult.insertedObjects.isEmpty && changeResult.removedObjects.isEmpty && !changeResult.hasMoves {
                    return false
                }
            }
            let fetchAssetCollection = fetchData.config.fetchAssetCollection
            fetchAssetCollection.enumerateAllAlbums(options: nil) { collection, _, stop in
                if collection.localIdentifier == assetCollection.collection?.localIdentifier {
                    assetCollection.collection = collection
                    stop.initialize(to: true)
                }
            }
            assetCollection.result = changeResult.fetchResultAfterChanges
            assetCollection.count = changeResult.fetchResultAfterChanges.count
            if assetCollection.count == 0 {
                assetCollection.update(
                    albumName: .textManager.picker.albumList.emptyAlbumName.text,
                    coverImage: config.emptyCoverImageName.image
                )
            }
            return true
        }
        return false
    }
}
