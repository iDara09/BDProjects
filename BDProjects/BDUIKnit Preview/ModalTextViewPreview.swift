//
//  ModalTextViewPreview.swift
//  BDProjects
//
//  Created by Dara Beng on 4/14/20.
//  Copyright © 2020 Dara Beng. All rights reserved.
//

import SwiftUI
import BDUIKnit


struct ModalTextViewPreview: View {
    
    @State private var todo = Todo()
    
    @State private var textViewModel = BDModalTextViewModel()
    @State private var presentSheet = false
    @State private var presentWithKeyboard = true
    @State private var characterLimit = ""
    @State private var commitButtonTitle = ""
    
    
    var body: some View {
        Form {
            Toggle("Present with Keyboard", isOn: $presentWithKeyboard)
            
            Toggle("Editable", isOn: $textViewModel.isEditable)
            
            Button("Title Color") {
                self.textViewModel.titleColor = .random()
            }
            .accentColor(textViewModel.titleColor ?? .primary)
            
            Button("Character Limit Color") {
                self.textViewModel.characterLimitColor = .random()
            }
            .accentColor(textViewModel.characterLimitColor ?? .primary)
            
            Button("Character Limit Warning Color") {
                self.textViewModel.characterLimitWarningColor = .random()
            }
            .accentColor(textViewModel.characterLimitWarningColor ?? .red)
            
            HStack {
                Text("Characters Limit")
                Spacer()
                TextField("nil", text: $characterLimit)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .onReceive(characterLimit.publisher.count(), perform: { _ in
                        let count = Int(self.characterLimit)
                        self.textViewModel.characterLimit = count
                    })
            }
            
            TextField("Commit Button Title", text: $commitButtonTitle)
            
            Section(header: Text("TEXT VIEW")) {
                Button(action: presentModalTextView) {
                    Text(todo.note)
                        .padding(.vertical)
                        .foregroundColor(.primary)
                }
            }
        }
        .sheet(isPresented: $presentSheet) {
            BDModalTextView(viewModel: self.$textViewModel)
        }
    }
    
    func presentModalTextView() {
        textViewModel.title = "Title"
        
        // assign the text to the text view's text before present
        textViewModel.text = todo.note
        
        textViewModel.onCommit = {
            // grab the text from the text view and dismiss
            self.todo.note = self.textViewModel.text
            self.textViewModel.isFirstResponder = false
            self.presentSheet = false
        }
        
        textViewModel.onCancel = {
            // ignore to update todo and dismiss
            self.textViewModel.isFirstResponder = false
            self.presentSheet = false
        }
        
        textViewModel.commitButtonTitle = commitButtonTitle.isEmpty ? "Done" : commitButtonTitle
        
        textViewModel.isFirstResponder = presentWithKeyboard
        presentSheet = true
    }
}


struct ModalTextViewPreview_Previews: PreviewProvider {
    static var previews: some View {
        ModalTextViewPreview()
    }
}
