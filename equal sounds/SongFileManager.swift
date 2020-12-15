//
//  SongFileManager.swift
//  equal sounds
//
//  Created by Gray, John Walker on 12/14/20.
//

import UIKit
import AVFoundation
import UniformTypeIdentifiers
import MobileCoreServices

class SongFileManager: FileManager, UIDocumentPickerDelegate
{
	static let musicFileExtensions = ["mp3","wav","flac","alac","aac","aiff"]
	
	var lastDocumentSelected: URL?
	
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) 
	{
		guard let myUrl = urls.first else {return}
		lastDocumentSelected = myUrl
	}
	
	func loadSongFiles(in directory: URL) -> [Song]?
	{
		do{
			let fileUrls = try contentsOfDirectory(atPath: directory.path)
			var loadedSongs = [Song]()
			for url in fileUrls
			{
				print("attempting to load data for \(url)")
				print("\(directory.appendingPathComponent(url).path)")
				if isValidSongUrl(for: directory.appendingPathComponent(url)), let song = fetchSongMetadata(for: directory.appendingPathComponent(url))
				{
					print("loaded data")
					loadedSongs.append(song)
				}
			}
			print("done loading data")
			return (loadedSongs.count > 0) ? loadedSongs : nil
		} catch {
			return nil
		}
	}
	
	func fetchSongMetadata(for url: URL) -> Song?
	{
		let asset = AVAsset(url: url)
		let metadata = asset.commonMetadata
		let title = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierTitle).first?.stringValue ?? url.lastPathComponent.description
		let artist = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierArtist).first?.stringValue
		let albumName = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierAlbumName).first?.stringValue
		let albumImageData = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierArtwork).first?.dataValue
		let albumImage: UIImage? = albumImageData == nil ? nil : UIImage(data: albumImageData!)
		let duration: Int = Int(asset.duration.seconds)
		let song = Song(name: title, artist: artist, albumName: albumName, duration: duration, albumImage: albumImage, url: url)
		print("loaded song \(title)")
		return song
	}
	
	func requestDocumentPicker() throws -> UIDocumentPickerViewController 
	{
		//let types = UTType.types(tag: "mp3", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
		//print(types)
		let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: [UTType(filenameExtension: "data")!])
		documentPickerController.directoryURL = try url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
		documentPickerController.delegate = self
		return documentPickerController
	}
	
	func loadSelectedFile() -> AVAudioFile?
	{
		if self.lastDocumentSelected == nil
		{
			return nil
		}
		let file = loadSongFile(at: self.lastDocumentSelected!)
		self.lastDocumentSelected = nil
		return file
	}
	
	func loadSongFile(at url: URL) -> AVAudioFile?
	{
		if !isValidSongUrl(for: url)
		{
			return nil
		}
		return openFile(at: url)
	}
	
	func isValidSongUrl(for url: URL) -> Bool
	{
		return !(url.pathExtension == "") && url.isFileURL && self.isReadableFile(atPath: url.path) && SongFileManager.musicFileExtensions.contains(url.pathExtension)
	}
	
	func openFile(at url: URL) -> AVAudioFile?
	{
		var audioFile: AVAudioFile?
		print("opening file in song file manager")
		do
		{
			print(url.path)
			print("loading song")
			try audioFile = AVAudioFile(forReading: url)
			print("loaded song")
			return audioFile
		} catch {
			print("an exception occured during audio file initialization")
			return nil
		}
	}
}

