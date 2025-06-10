import SwiftUI

struct ParagraphEntry {
    let title: String
    let text: String
    let date: String
}

struct HomeView: View{
    let totalWeeks = 30
    @State private var weekProgress = 1
    @State private var wordsStudied = [false, false, false, false, false, false, false, false, false, false]
    @State private var submittedParagraphs: [ParagraphEntry] = []
    @State private var weeklyWords = ["Astonish", "Unexpectedly", "Conference", "Session", "Summarize", "Legend", "Quote", "Innumerable", "Journalism", "Interview"]
    
    func addParagraph(paragraph: String){
        let dummyTitle = "Untitled"
        let dummyDate = "June 8, 2025"
        let newEntry = ParagraphEntry(title:dummyTitle, text: paragraph, date:dummyDate)
        submittedParagraphs.append(newEntry)
    }
    var body: some View {
        VStack {
            Text("Logo")
                .font(.largeTitle)
                .padding()
            Text("Week \(weekProgress) of \(totalWeeks)")
                .padding()
            Text("10 words this week | \(wordsStudied.filter{$0}.count) covered")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
            NavigationLink(destination:
                StudyWeek(
                    weeklyWords: weeklyWords,
                    definitionsWords: [
                        "to amaze; to surprise",
                        "suddenly; in an unannounced way; in a way not known before",
                        "a formal meeting for discussion",
                        "a meeting of a group; a series of such meetings; a period of activity; a school semester or term",
                        "to give a brief account of; to say briefly",
                        "a popular story or myth handed down for generations; a person whose deeds are remembered as stories; a note on an illustration or map",
                        "to reproduce word for word; to refer to as an example; to state, as a price; words repeated exactly",
                        "too many to be counted; countless",
                        "writing and publishing news",
                        "a face-to-face meeting for evaluating or questioning; to meet with for the purpose of evaluating or asking questions"
                    ],
                    wordsStudied: $wordsStudied
                )
            ) {
                Text("Quip about reading")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            NavigationLink(destination:
                            ParagraphBuilder(weeklyWords: weeklyWords, onSubmit: addParagraph)
            ) {
                Text("Quip about writing")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    
            }
            NavigationLink(destination:
                            ParagraphArchives(submittedParagraphs: submittedParagraphs)
            ) {
              Text("Quip about publishing")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            
        }
        .navigationTitle("Context Matters")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StudyWeek: View {
    let weeklyWords: [String]
    let definitionsWords: [String]
    @State private var currentWord = 0
    @State private var showDefinition = false
    @Binding var wordsStudied: [Bool]
    
    var body: some View {
        VStack {
            Text("\(weeklyWords[currentWord % 10])")
                .font(.largeTitle)

            HStack {
                Button {
                   currentWord = (currentWord - 1 + 10) % 10
                   showDefinition = false
                }
                label: {Image(systemName: "arrowshape.backward")}
                .padding()
                .background(Color(red: 25/255, green: 25/255, blue: 112/255))
                .foregroundColor(.white)
                .cornerRadius(20)
                
                Button {
                   currentWord = (currentWord + 1) % 10
                   showDefinition = false
                }
                label: {Image(systemName: "arrowshape.forward")}
                .padding()
                .background(Color(red: 25/255, green: 25/255, blue: 112/255))
                .foregroundColor(.white)
                .cornerRadius(20)
            }

                Button("Show Definition") {
                    showDefinition = true
                    wordsStudied[currentWord % 10] = true
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.blue.opacity(0.2)))
            
            if showDefinition {
                Text("\(definitionsWords[currentWord])")
                .frame(maxWidth: 350)
            }
            
        }
        .navigationTitle("Your Weekly Words")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ParagraphBuilder: View{
    let weeklyWords: [String]
    let columns = [GridItem(.adaptive(minimum: 100))]
    let onSubmit: (String) -> Void
    
    @State private var paragraph = ""
    var body: some View{
        VStack{
            ScrollView{
                LazyVGrid(columns:columns, spacing: 10){
                    ForEach(weeklyWords, id:\.self){ word in
                        Text(word)
                            .padding()
                            .background(Color.blue.opacity(0.3))
                            .cornerRadius(12)
                    }
                }
            }
            .frame(maxHeight:282)
            
            TextEditor(
                text: $paragraph,
          
            )
            .scrollContentBackground(.hidden)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
               RoundedRectangle(cornerRadius: 10)
                 .stroke(Color.gray.opacity(0.4), lineWidth: 1)
               )
            .padding()
            
            Button("Submit"){
                onSubmit(paragraph)
            }
            .padding()
            .background(Color.blue.opacity(0.3))
            .cornerRadius(12)
            .foregroundStyle(Color.black)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct ParagraphArchives: View{
    let submittedParagraphs: [ParagraphEntry]
    var body: some View{
        ScrollView{
            VStack{
                ForEach(submittedParagraphs.indices, id:\.self ){index in
                    let paragraph = submittedParagraphs[index]
                    HStack{
                        Text("\(index + 1)")
                            .frame(width:50)
                            .padding(10)
                        Text("\(paragraph.title)")
                            .frame(width: 245)
                        Text("\(paragraph.date)")
                            .frame(width:100)
                            .padding(10)
                    }
                    .background(index % 2 == 0 ? Color.blue.opacity(0.2) : Color.clear)
                    .foregroundStyle(Color.black)

                }
            }
        }
    }
}
     
struct ContentView: View {
    var body:some View{
        NavigationStack{
            HomeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
