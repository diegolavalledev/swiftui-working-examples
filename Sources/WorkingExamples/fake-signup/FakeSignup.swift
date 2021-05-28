import SwiftUI
import Foundation
import Combine

fileprivate func usernameAvailable(_ username: String, completion: @escaping (Bool) -> ()) -> () {
  DispatchQueue.main .async {
    if (username == "john") {
      completion(true)
    } else {
      completion(false)
    }
  }
}

fileprivate class SignUpFormModel: ObservableObject {
  
  @Published var username: String = ""
  @Published var password: String = ""
  @Published var passwordAgain: String = ""
  
  var validatedPassword: AnyPublisher<String?, Never> {
    $password.combineLatest($passwordAgain) { password, passwordAgain in
      guard password == passwordAgain, password.count >= 8 else {
        return "invalid"
      }
      return password
    }
    .map { $0 == "password" ? "invalid" : $0 }
    .eraseToAnyPublisher()
  }
  
  var validatedUsername: AnyPublisher<String?, Never> {
    return $username
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .removeDuplicates()
      .flatMap { username in
        return Future { promise in
          usernameAvailable(username) { available in
            promise(.success(available ? username : nil))
          }
        }
    }
    .eraseToAnyPublisher()
  }
  
  var validatedCredentials: AnyPublisher<(String, String)?, Never> {
    validatedUsername.combineLatest(validatedPassword) { username, password in
      guard let uname = username, let pwd = password else { return nil }
      return (uname, pwd)
    }
    .eraseToAnyPublisher()
  }
}

#if os(iOS)

struct FakeSignup: View {
  
  @ObservedObject private var model = SignUpFormModel()

  @State var usernameAvailable = false
  @State var passwordsValid = false
  @State var signUpDisabled = true
  @State var alertShown = false

  init() { }
  
  init(usernameAvailable: Bool) {
    self.usernameAvailable = usernameAvailable
  }

  var body: some View {
    NavigationView {
      VStack {
        Form {
          Section(header: Text("Pick an available username")) {
            HStack {
              TextField("Username (use \"john\")", text: $model.username)
                .autocapitalization(.none)
                .textContentType(.nickname)
                .keyboardType(.alphabet)
                .tag(0)
              Text(usernameAvailable ? "✅" : "❌")
                .onReceive(model.validatedUsername) {
                  self.usernameAvailable = $0 != nil
              }
            }
          }
          Section(footer: Text("8+ characters, not \"password\"")) {
            SecureField("Password", text: $model.password)
              .autocapitalization(.none)
              .textContentType(.password)
              .keyboardType(.alphabet)
              .tag(1)
            HStack {
              SecureField("Password again", text: $model.passwordAgain)
                .autocapitalization(.none)
                .textContentType(.password)
                .keyboardType(.alphabet)
                .tag(2)
              Text(passwordsValid ? "✅" : "❌")
                .onReceive(model.validatedPassword) {
                  self.passwordsValid = $0 != "invalid"
              }
            }
          }

          Section {
            Button("Sign up") {
              self.alertShown.toggle()
            }
            .disabled(signUpDisabled)
            .onReceive(model.validatedCredentials) {
              guard let credentials = $0 else {
                self.signUpDisabled = true
                return
              }
              let (_, validPassword) = credentials
              guard validPassword != "invalid"  else {
                self.signUpDisabled = true
                return
              }
              self.signUpDisabled = false
            }
          }
          .frame(maxWidth: .infinity, alignment: .center)
        }
        Spacer()
      }
      .navigationBarTitle("Welcome!")
    }
    .alert(isPresented: $alertShown) {
      Alert(title: Text("Congratuations!"), message: Text("You have signed up with username \(self.model.username) and password \(self.model.password)."), dismissButton: .default(Text("Yay!")))
    }
  }
}

struct FakeSignup_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      FakeSignup()
      FakeSignup(usernameAvailable: true)
    }
  }
}

#endif
