//
//  ElevenAudioBooksApp.swift
//  ElevenAudioBooks
//
//  Created by H6nry on 12.03.21.
//

import SwiftUI

struct AudioBookTrack: Identifiable {
	let id = UUID()
	var trackTitle: String
	var year: String
	var bkGeneratedItemID: String
	var artist: String
	var genre: String
	let path: String
	var trackNr: Int
	let plistSkeleton: Dictionary<String, Any>
}

struct AudioBook: Identifiable {
	let id = UUID()
	var name: String
	var year: String
	var bkGeneratedItemID: String
	var artist: String
	var genre: String
	var items: Dictionary<UUID, AudioBookTrack>
	let plistSkeleton: Dictionary<String, Any>
	var itemsSortedByTrackNrThenName: Array<AudioBookTrack> {
		get {
			let itemsListu:Array<AudioBookTrack> = self.items.map { $0.value }
			return itemsListu.sorted(by: {
				if ($0.trackNr != $1.trackNr) {
					return $0.trackNr < $1.trackNr
				} else {
					return $0.trackTitle.lowercased() < $1.trackTitle.lowercased()
				}
			})
		}
	}
}

class ViewModel: ObservableObject {
	@Published var audioBooks:Dictionary<UUID, AudioBook> = [:]
	private var booksPlistSkeleton: Dictionary<String, Any> = [:]
	
	
	init() {
		print("hello?")
		/*
		//Experimental stuff....
		let connection = NSXPCConnection(machServiceName: "com.apple.BKAgentService", options: NSXPCConnection.Options(rawValue: 0))
		connection.remoteObjectInterface = NSXPCInterface(with: BKAgentService.self)
		connection.resume()
		
		let service = connection.remoteObjectProxyWithErrorHandler { error in
			  print("Received error:", error)
			} as? BKAgentService
		
		
		service!.fetchBooks({(obj:Any, e:Error) -> Void in
			print(obj)
			print(e)
		})*/
		
		let homeURL = FileManager.default.homeDirectoryForCurrentUser
		let booksLibraryURL = homeURL.appendingPathComponent("Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks/Books/", isDirectory: true)
		let booksPlistURL = booksLibraryURL.appendingPathComponent("Books.plist")
		
		//First, make a backup file of the library!
		let booksPlistBackupURL = booksLibraryURL.appendingPathComponent("Books.plist.backup")
		do {
			if FileManager.default.fileExists(atPath: booksPlistBackupURL.path) {
				try FileManager.default.removeItem(at: booksPlistBackupURL)
			}
			try FileManager.default.copyItem(at: booksPlistURL, to: booksPlistBackupURL)
		} catch {
			print("Backup failed!!!")
			exit(1)
		}
		
		//Read File into a dictionary
		var bplist: Dictionary<String, Any> = [:]
		
		do {
			let infoPlistData = try Data(contentsOf: booksPlistURL)
			
			if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? Dictionary<String, Any> {
				bplist = dict
			}
		} catch {
			print(error)
		}
		
		let books:[Dictionary] = bplist["Books"] as! [Dictionary<String, Any>]
		var booksv:Array<Dictionary<String, Any>> = [] //The part of books which won't be processed by ElevenAudioBooks
		
		for book in books {
			let type = book["BKBookType"] as! String
			if type == "audiobook" {
				let name = book["itemName"] as! String
				let year = book["year"] as! String
				let id = book["BKGeneratedItemId"] as! String
				let artist = book["artistName"] as! String
				let genre = book["genre"] as! String
				
				// Remove all indexed keys and values, to store the rest for later
				var bookv = book
				bookv.removeValue(forKey: "itemName")
				bookv.removeValue(forKey: "year")
				bookv.removeValue(forKey: "BKGeneratedItemId")
				bookv.removeValue(forKey: "artistName")
				bookv.removeValue(forKey: "genre")
				
				var items:Dictionary<UUID, AudioBookTrack> = [:]
				let bkparts = book["BKParts"] as! Array<Dictionary<String, Any>>
				
				for item in bkparts {
					let trackTitle = item["BKTrackTitle"] as! String
					let year = item["year"] as! String
					let bkGeneratedItemID = item["BKGeneratedItemId"] as! String
					let artist = item["artistName"] as! String
					let genre = item["genre"] as! String
					let path = item["path"] as! String
					let tracknr = item["BKTrackNumber"] as! Int
					
					// Remove all indexed keys and values, to store the rest for later
					var itemv = item
					itemv.removeValue(forKey: "BKTrackTitle")
					itemv.removeValue(forKey: "year")
					itemv.removeValue(forKey: "BKGeneratedItemId")
					itemv.removeValue(forKey: "artistName")
					itemv.removeValue(forKey: "genre")
					itemv.removeValue(forKey: "path")
					itemv.removeValue(forKey: "BKTrackNumber")
					
					let track = AudioBookTrack(trackTitle: trackTitle, year: year, bkGeneratedItemID: bkGeneratedItemID, artist: artist, genre: genre, path: path, trackNr: tracknr, plistSkeleton: itemv)
					
					items[track.id] = track
				}
				
				
				let audiobook = AudioBook(name: name, year: year, bkGeneratedItemID: id, artist: artist, genre: genre, items: items, plistSkeleton: bookv)
				/*let audiobook = AudioBook()
				audiobook.name = name
				audiobook.year = year
				audiobook.bkGeneratedItemID = id
				audiobook.artist = artist
				audiobook.genre = genre
				audiobook.items = items*/
				
				audioBooks[audiobook.id] = audiobook
			} else {
				booksv.append(book)
			}
		}
		
		//Put the unused books into the plist dict, removing everything else
		bplist["Books"] = booksv
		booksPlistSkeleton = bplist
		//print(booksPlistSkeleton)
		
		
		
		//Get values, modify, merge, etc.
		/*var books:[Dictionary] = bplist?["Books"] as! [Dictionary<String, Any>]
		print(books[11]["itemName"] as Any)
		books[11]["itemName"] = "Döner Schäfchentangol"
		
		
		bplist!["Books"] = books
		
		//Write the dictionary back to file
		do {
			let dataToWrite = try PropertyListSerialization.data(fromPropertyList: bplist ?? "", format: PropertyListSerialization.PropertyListFormat.binary, options: 0)
			try dataToWrite.write(to: booksPlistURL)
		} catch {
			print("error writing file")
		}*/
	}
	
	func saveToLibrary() -> Void {
		print("saving to library...")
		var skeleton = booksPlistSkeleton
		
		var booksPlist:Array<Dictionary<String, Any>> = []
		let books:Array<AudioBook> = audioBooks.map { $0.value }
		
		for book in books {
			var dict:Dictionary<String, Any> = book.plistSkeleton
			
			dict["itemName"] = book.name
			dict["year"] = book.year
			dict["BKGeneratedItemId"] = book.bkGeneratedItemID
			dict["artistName"] = book.artist
			dict["genre"] = book.genre
			
			var itemsPlist:Array<Dictionary<String, Any>> = []
			let items: Array<AudioBookTrack> = book.itemsSortedByTrackNrThenName
			
			for item in items {
				var idict:Dictionary<String, Any> = item.plistSkeleton
				
				idict["BKTrackTitle"] = item.trackTitle
				idict["year"] = item.year
				idict["BKGeneratedItemId"] = item.bkGeneratedItemID
				idict["artistName"] = item.artist
				idict["genre"] = item.genre
				idict["path"] = item.path
				idict["BKTrackNumber"] = item.trackNr
				
				itemsPlist.append(idict)
			}
			
			dict["BKParts"] = itemsPlist
			booksPlist.append(dict)
		}
		var skeletonBooks:Array<Any> = skeleton["Books"] as! Array<Any>
		skeletonBooks.append(contentsOf: booksPlist)
		
		skeleton["Books"] = skeletonBooks
		
		//print(skeleton)
		
		killiBooksXandRemoveiBooksXSQL()
		
		let homeURL = FileManager.default.homeDirectoryForCurrentUser
		let booksLibraryURL = homeURL.appendingPathComponent("Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks/Books/", isDirectory: true)
		let booksPlistURL = booksLibraryURL.appendingPathComponent("Books.plist")
		
		do {
			let dataToWrite = try PropertyListSerialization.data(fromPropertyList: skeleton, format: PropertyListSerialization.PropertyListFormat.binary, options: 0)
			try dataToWrite.write(to: booksPlistURL)
		} catch {
			print("error writing file")
		}
		
		
	}
	
	func reload() -> Void {
		print("reloading... todo") //TODO
	}
	
	func killiBooksXandRemoveiBooksXSQL() -> Void {
		shell("killall Books")
		shell("PROZID=$(pgrep com.apple.BKAgentService); kill -9 $PROZID")
		
		let homeURL = FileManager.default.homeDirectoryForCurrentUser
		let iBooksXLibraryURL = homeURL.appendingPathComponent("Library/Containers/com.apple.iBooksX/Data/Documents/", isDirectory: true)
		let booksLibraryURL = iBooksXLibraryURL.appendingPathComponent("BKLibrary/", isDirectory: true)
		
		//First, make a backup
		let booksLibraryBackupURL = iBooksXLibraryURL.appendingPathComponent("BKLibrary_Backup/", isDirectory: true)
		do {
			if FileManager.default.fileExists(atPath: booksLibraryURL.path) {
				if FileManager.default.fileExists(atPath: booksLibraryBackupURL.path) {
					try FileManager.default.removeItem(at: booksLibraryBackupURL)
				}
				
				try FileManager.default.moveItem(at: booksLibraryURL, to: booksLibraryBackupURL)
			}
		} catch {
			print("Backup and/or Move failed!!!   ")
			print(error)
			exit(1)
		}
	}
	
	@discardableResult
	private func shell(_ command: String) -> String {
		let task = Process()
		let pipe = Pipe()
		
		task.standardOutput = pipe
		task.standardError = pipe
		task.arguments = ["-c", command]
		task.launchPath = "/bin/zsh"
		task.launch()
		
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		let output = String(data: data, encoding: .utf8)!
		
		return output
	}
}


@main
struct ElevenAudioBooksApp: App {
	@StateObject var viewModel  = ViewModel()
	@State private var selectedBook: UUID? = UUID()
	@State private var selectedItem: UUID? = UUID()
	
    var body: some Scene {
        WindowGroup {
			ContentView(viewModel: viewModel, selectedBook: $selectedBook, selectedItem: $selectedItem)
		}.commands {
			SidebarCommands()
			CommandGroup(after: CommandGroupPlacement.saveItem, addition: {
				Button("Save to Library") {
					viewModel.saveToLibrary()
				}
				Button("Reload from Library") {
					viewModel.reload()
				}
			})
		}
    }
}
