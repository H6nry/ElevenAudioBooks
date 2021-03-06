//
//  ContentView.swift
//  ElevenAudioBooks
//
//  Created by H6nry on 12.03.21.
//

import SwiftUI
import AppKit


/*
enum EditFieldEditType {
	case name
	case year
	case genre
	case artist
	case t_title
	case t_trackNr
	case t_year
	case t_genre
	case t_artist
}



struct ContentView: View {
	@ObservedObject var viewModel: ViewModel
	@Binding var selectedBook: UUID?
	@Binding var selectedItem: UUID?
	
	@State private var saveChangesWarningPresented: Bool = false
	
    var body: some View {
		VStack {
			NavigationView {
				let booksList:Array<AudioBook> = viewModel.audioBooks.map { $0.value }
				
				List(booksList, id: \.id) { book in
					NavigationLink(destination: AudioBookDetailView(viewModel: viewModel, selectedBook: $selectedBook, selectedItem: $selectedItem), tag: book.id, selection: $selectedBook) {
						Text(book.name)
					}
				}.listStyle(SidebarListStyle())
				
				//Placeholders
				Text("AudioBook")
					.frame(minWidth: 100, idealWidth: 150, maxWidth: 200, maxHeight: .infinity)
					//.background(Color(red: 222/255, green: 228/255, blue: 234/255, opacity: 1))
				Text("Items")
					.frame(minWidth: 100, idealWidth: 150, maxWidth: 200, maxHeight: .infinity)
				Text("Edit Item")
					.frame(minWidth: 100, idealWidth: 150, maxWidth: 200, maxHeight: .infinity)
			}.frame(minWidth: 800, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
			.toolbar() {
				ToolbarItem(placement: ToolbarItemPlacement.navigation) {
					Button(action: {
						NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
					}, label: {
						Image(systemName: "sidebar.leading")
					}).help("Toggle Side Bar")
					Spacer()
				}
				
				ToolbarItem() {
					Button(action: {
						viewModel.reload()
					}, label: {
						Image(systemName: "arrow.triangle.2.circlepath")
					}).help("Discard changes and reload from Database")
				}
				
				ToolbarItem() {
					Button(action: {
						saveChangesWarningPresented = true
					}, label: {
						Image(systemName: "tray.and.arrow.down.fill")
					})
					.help("Save changes to Library")
					.alert(isPresented: $saveChangesWarningPresented, content: {
						Alert(title: Text("Warning"), message: Text("ibooks-library-delete-kill-warning"), primaryButton: .destructive(Text("I have a Backup. Proceed.")) {
							viewModel.saveToLibrary()
						}, secondaryButton: .cancel())
					})
				}
			}
		}
	}
}


struct AudioBookDetailView: View {
	@ObservedObject var viewModel: ViewModel
	@Binding var selectedBook: UUID?
	@Binding var selectedItem: UUID?
	@State private var isEditNamePopoverPresented: Bool = false
	
	
	var body: some View {
		//NavigationView {
			List {
				
				/*Button("Edit") {
					viewModel.audioBooksList[0].name = "DISODASO"
					selectedBook = viewModel.audioBooksList[0]
					//self.isEditNamePopoverPresented = true
				}*//*.popover(isPresented: self.$isEditNamePopoverPresented) {
					Text("Popover is Presented").frame(width: 500, height: 500)
				}*/
				/*HStack {
					Text("Name: ")
					TextField("Name", text: name)
				}*/
				EditFieldView(viewModel: viewModel, selectedBook: $selectedBook, selectedItem: $selectedItem, editFieldType: EditFieldEditType.name)
				EditFieldView(viewModel: viewModel, selectedBook: $selectedBook, selectedItem: $selectedItem, editFieldType: EditFieldEditType.artist)
				EditFieldView(viewModel: viewModel, selectedBook: $selectedBook, selectedItem: $selectedItem, editFieldType: EditFieldEditType.genre)
				EditFieldView(viewModel: viewModel, selectedBook: $selectedBook, selectedItem: $selectedItem, editFieldType: EditFieldEditType.year)
				
				NavigationLink(destination: AudioBookItemsView(viewModel: viewModel, selectedBook: $selectedBook, selectedItem: $selectedItem)) {
					HStack {
						Text("Tracks")
						Spacer()
						Image(systemName: "chevron.forward").frame(alignment: Alignment.trailing)
					}
				}
			}
		//}
	}
}


struct AudioBookItemsView: View {
	@ObservedObject var viewModel: ViewModel
	@Binding var selectedBook: UUID?
	@Binding var selectedItem: UUID?
	//@State var itemsList: Array<AudioBookTrack> = []
	
	var body: some View {
		/*let itemsListu:Array<AudioBookTrack> = viewModel.audioBooks[selectedBook!]!.items.map { $0.value }
		let itemsList:Array<AudioBookTrack> = itemsListu.sorted(by: {$0.trackNr < $1.trackNr})*/
		let itemsList: Array<AudioBookTrack> = viewModel.audioBooks[selectedBook!]!.itemsSortedByTrackNrThenName
		
			List(itemsList, id: \.id) { item in
				NavigationLink(destination: AudioBookItemDetailView(viewModel: viewModel, selectedBook: $selectedBook, selectedItem: $selectedItem), tag: item.id, selection: $selectedItem) {
					HStack {
						Text(String(item.trackNr) + ". " + item.trackTitle).frame(maxHeight: 50)
						Spacer()
						Image(systemName: "chevron.forward").frame(alignment: Alignment.trailing)
					}
				}
			}/*.onAppear() {
			let itemsListu:Array<AudioBookTrack> = viewModel.audioBooks[selectedBook!]!.items.map { $0.value }
			itemsList = itemsListu.sorted(by: {$0.trackNr < $1.trackNr})
			}*/
	}
}

struct AudioBookItemDetailView: View {
	@ObservedObject var viewModel: ViewModel
	@Binding var selectedBook: UUID?
	@Binding var selectedItem: UUID?
	
	var body: some View {
		List {
			EditFieldView(viewModel: viewModel, selectedBook: $selectedBook, selectedItem: $selectedItem, editFieldType: EditFieldEditType.t_trackNr)
			EditFieldView(viewModel: viewModel, selectedBook: $selectedBook, selectedItem: $selectedItem, editFieldType: EditFieldEditType.t_title)
			EditFieldView(viewModel: viewModel, selectedBook: $selectedBook, selectedItem: $selectedItem, editFieldType: EditFieldEditType.t_year)
			EditFieldView(viewModel: viewModel, selectedBook: $selectedBook, selectedItem: $selectedItem, editFieldType: EditFieldEditType.t_genre)
			EditFieldView(viewModel: viewModel, selectedBook: $selectedBook, selectedItem: $selectedItem, editFieldType: EditFieldEditType.t_artist)
		}
	}
}

struct EditFieldView: View {
	@ObservedObject var viewModel: ViewModel
	@Binding var selectedBook: UUID?
	@Binding var selectedItem: UUID?
	let editFieldType: EditFieldEditType
	
	var body: some View {
		let name = Binding<String>(get: {
			let book = viewModel.audioBooks[selectedBook!]
			if (book != nil) {
				return book!.name
			}
			
			return "UNNAMED"
		}, set: {
			let boo = selectedBook
			viewModel.audioBooks[selectedBook!]?.name = $0
			selectedBook = boo
		})
		
		let artist = Binding<String>(get: {
			let book = viewModel.audioBooks[selectedBook!]
			if (book != nil) {
				return book!.artist
			}
			
			return ""
		}, set: {
			let boo = selectedBook
			viewModel.audioBooks[selectedBook!]?.artist = $0
			selectedBook = boo
		})
		
		let genre = Binding<String>(get: {
			let book = viewModel.audioBooks[selectedBook!]
			if (book != nil) {
				return book!.genre
			}
			
			return ""
		}, set: {
			let boo = selectedBook
			viewModel.audioBooks[selectedBook!]?.genre = $0
			selectedBook = boo
		})
		
		let year = Binding<String>(get: {
			let book = viewModel.audioBooks[selectedBook!]
			if (book != nil) {
				return book!.year
			}
			
			return ""
		}, set: {
			let boo = selectedBook
			viewModel.audioBooks[selectedBook!]?.year = $0
			selectedBook = boo
		})
		
		
		let t_trackNr = Binding<String>(get: {
			let book = viewModel.audioBooks[selectedBook!]
			if (book != nil && selectedItem != nil) {
				let item = book?.items[selectedItem!]
				if (item != nil) {
					return String(item!.trackNr)
				}
			}
			return "0"
		}, set: {
			let boo = selectedBook
			let ite = selectedItem
			if (boo != nil && ite != nil) {
				viewModel.audioBooks[selectedBook!]?.items[selectedItem!]?.trackNr = Int($0) ?? 0
			}
			selectedBook = boo
			selectedItem = ite
		})
		
		let t_title = Binding<String>(get: {
			let book = viewModel.audioBooks[selectedBook!]
			if (book != nil && selectedItem != nil) {
				let item = book?.items[selectedItem!]
				if (item != nil) {
					return item!.trackTitle
				}
			}
			return ""
		}, set: {
			if (selectedBook != nil && selectedItem != nil) {
				let boo = selectedBook
				let ite = selectedItem
				viewModel.audioBooks[selectedBook!]?.items[selectedItem!]?.trackTitle = $0
				selectedBook = boo
				selectedItem = ite
			}
		})
		
		let t_year = Binding<String>(get: {
			let book = viewModel.audioBooks[selectedBook!]
			if (book != nil && selectedItem != nil) {
				let item = book?.items[selectedItem!]
				if (item != nil) {
					return item!.year
				}
			}
			return ""
		}, set: {
			let boo = selectedBook
			let ite = selectedItem
			viewModel.audioBooks[selectedBook!]?.items[selectedItem!]?.year = $0
			selectedBook = boo
			selectedItem = ite
		})
		
		let t_genre = Binding<String>(get: {
			let book = viewModel.audioBooks[selectedBook!]
			if (book != nil && selectedItem != nil) {
				let item = book?.items[selectedItem!]
				if (item != nil) {
					return item!.genre
				}
			}
			return ""
		}, set: {
			let boo = selectedBook
			let ite = selectedItem
			viewModel.audioBooks[selectedBook!]?.items[selectedItem!]?.genre = $0
			selectedBook = boo
			selectedItem = ite
		})
		
		let t_artist = Binding<String>(get: {
			let book = viewModel.audioBooks[selectedBook!]
			if (book != nil && selectedItem != nil) {
				let item = book?.items[selectedItem!]
				if (item != nil) {
					return item!.artist
				}
			}
			return ""
		}, set: {
			let boo = selectedBook
			let ite = selectedItem
			viewModel.audioBooks[selectedBook!]?.items[selectedItem!]?.artist = $0
			selectedBook = boo
			selectedItem = ite
		})
		
		
		HStack {
			switch editFieldType {
			case .name:
				Text("Name:")
				TextField("Name", text: name)
			case .year:
				Text("Year:")
				TextField("Year", text: year)
			case .genre:
				Text("Genre:")
				TextField("Genre", text: genre)
			case .artist:
				Text("Artist:")
				TextField("Artist", text: artist)
			case .t_title:
				Text("Title:")
				TextField("Title", text:t_title)
			case .t_trackNr:
				Text("Track No.:")
				TextField("Track No.", text:t_trackNr)
			case .t_year:
				Text("Year:")
				TextField("Year", text:t_year)
			case .t_genre:
				Text("Genre:")
				TextField("Genre", text:t_genre)
			case .t_artist:
				Text("Artist:")
				TextField("Artist", text:t_artist)
			}
		}.contextMenu {
			Button("Apply to all titles in audiobook") {
					print("TODO!!!")
			}.disabled(!((editFieldType == .artist) || (editFieldType == .year) || (editFieldType == .genre)))
		}
	}
}

struct PlayerView: View {
	var body: some View {
		Text("hh") //TODO
	}
}
*/





// This is a rewrite. Much better, less bugs, cleaner, and I still don't understand 100 % of what it's doing.
// The core rewrite is to not depend on dictionaries, but rather on arrays. I don't understand why dictionaries won't work, but they don't.

struct ContentView2: View {
	@EnvironmentObject var viewModel: ViewModel
	@State private var saveChangesWarningPresented: Bool = false
	
	var booksList:Array<AudioBook> {
		viewModel.audioBooksList.sorted(by: { $0.name < $1.name})
	}
	
	
	var body: some View {
		VStack {
			NavigationView {
				List(booksList, id: \.id) { book in
					NavigationLink(destination: AudioBookDetailView2(selectedBook: book)) {
						Text(book.name)
					}
					.contextMenu {
						Button("View in Finder") {
							NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: book.pathURL.path)
						}
					}
				}.listStyle(SidebarListStyle())
				
				//Placeholders
				Text("AudioBook")
					.frame(minWidth: 100, idealWidth: 150, maxWidth: 200, maxHeight: .infinity)
				Text("Items")
					.frame(minWidth: 100, idealWidth: 150, maxWidth: 200, maxHeight: .infinity)
				Text("Edit Item")
					.frame(minWidth: 100, idealWidth: 150, maxWidth: 200, maxHeight: .infinity)
			}
			.frame(minWidth: 800, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
			.toolbar() {
				ToolbarItem(placement: ToolbarItemPlacement.navigation) {
					Button(action: {
						NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
					}, label: {
						Image(systemName: "sidebar.leading")
					}).help("Toggle Side Bar")
					Spacer()
				}
				
				ToolbarItem() {
					Button(action: {
						viewModel.reload()
					}, label: {
						Image(systemName: "arrow.triangle.2.circlepath")
					})
					.help("Discard changes and reload from Database")
					.disabled(true)
				}
				
				ToolbarItem() {
					Button(action: {
						saveChangesWarningPresented = true
					}, label: {
						Image(systemName: "tray.and.arrow.down.fill")
					})
					.help("Save changes to Library")
					.alert(isPresented: $saveChangesWarningPresented, content: {
						Alert(title: Text("Warning"), message: Text("ibooks-library-delete-kill-warning"), primaryButton: .destructive(Text("I have a Backup. Proceed.")) {
							viewModel.saveToLibrary()
						}, secondaryButton: .cancel())
					})
				}
			}
		}
	}
}


struct AudioBookDetailView2: View {
	@EnvironmentObject var viewModel: ViewModel
	var selectedBook: AudioBook
	
	var selectedBookIndex: Int {
		viewModel.audioBooksList.firstIndex(where: { $0.id == selectedBook.id})!
	}
	
	
	var body: some View {
		List {
			HStack {
				Text("Name") + Text(":")
				TextField("Name", text: $viewModel.audioBooksList[selectedBookIndex].name)
			}
			HStack {
				Text("Artist") + Text(":")
				TextField("Artist", text: $viewModel.audioBooksList[selectedBookIndex].artist)
			}
			HStack {
				Text("Genre") + Text(":")
				TextField("Genre", text: $viewModel.audioBooksList[selectedBookIndex].genre)
			}
			HStack {
				Text("Year") + Text(":")
				TextField("Year", text: $viewModel.audioBooksList[selectedBookIndex].year)
			}
			
			NavigationLink(destination: AudioBookItemsView2(selectedBook: selectedBook)) {
				HStack {
					Text(selectedBook.name).frame(maxHeight: 50)
					Spacer()
					Image(systemName: "chevron.forward").frame(alignment: Alignment.trailing)
				}
			}
		}
	}
}


struct AudioBookItemsView2: View {
	@EnvironmentObject var viewModel: ViewModel
	var selectedBook: AudioBook
	
	var selectedBookIndex: Int {
		viewModel.audioBooksList.firstIndex(where: { $0.id == selectedBook.id})!
	}
	
	var itemsList:Array<AudioBookTrack> {
		selectedBook.itemsList.sorted(by: { $0.trackNr < $1.trackNr})
	}
	
	
	var body: some View {
		List(itemsList, id: \.id) { item in
			NavigationLink(destination: AudioBookItemDetailView2(selectedBook: selectedBook, selectedItem: item)) {
				HStack {
					Text(String(item.trackNr)) + Text(". ") + Text(item.trackTitle)
					Spacer()
					Image(systemName: "chevron.forward").frame(alignment: Alignment.trailing)
				}.frame(maxHeight: 50)
			}
		}
	}
}


struct AudioBookItemDetailView2: View {
	@EnvironmentObject var viewModel: ViewModel
	var selectedBook: AudioBook
	var selectedItem: AudioBookTrack
	
	var selectedBookIndex: Int {
		viewModel.audioBooksList.firstIndex(where: { $0.id == selectedBook.id })!
	}
	
	var selectedItemIndex: Int {
		viewModel.audioBooksList[selectedBookIndex].itemsList.firstIndex(where: { $0.id == selectedItem.id })!
	}
	
	
	var body: some View {
		List {
			HStack {
				Text("Track Nr.") + Text(":")
				TextField("Track Nr.", value: $viewModel.audioBooksList[selectedBookIndex].itemsList[selectedItemIndex].trackNr, formatter: NumberFormatter()) // The NumberFormatter allows an Int as a binding.
			}
			HStack {
				Text("Title") + Text(":")
				TextField("Title", text: $viewModel.audioBooksList[selectedBookIndex].itemsList[selectedItemIndex].trackTitle)
			}
			HStack {
				Text("Artist") + Text(":")
				TextField("Artist", text: $viewModel.audioBooksList[selectedBookIndex].itemsList[selectedItemIndex].artist)
			}
			HStack {
				Text("Genre") + Text(":")
				TextField("Genre", text: $viewModel.audioBooksList[selectedBookIndex].itemsList[selectedItemIndex].genre)
			}
			HStack {
				Text("Year") + Text(":")
				TextField("Year", text: $viewModel.audioBooksList[selectedBookIndex].itemsList[selectedItemIndex].year)
			}
			Image(nsImage: NSImage(data: selectedItem.artwork) ?? NSImage()).resizable().scaledToFit()
		}
	}
}
