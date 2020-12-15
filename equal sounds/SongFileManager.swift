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
	
	func requestDocumentPicker() -> UIDocumentPickerViewController
	{
		let types = UTType.types(tag: "mp3", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
		let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: types)
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

