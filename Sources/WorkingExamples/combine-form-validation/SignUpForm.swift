import SwiftUI

public struct SignUpForm: View {
  
  @ObservedObject var model = SignUpFormModel()

  @State var usernameAvailable = false
  @State var passwordsValid = false
  @State var signUpDisabled = true
  @State var alertShown = false

  public init() { }
  
  public init(usernameAvailable: Bool) {
    self.usernameAvailable = usernameAvailable
  }

  public var body: some View {
    NavigationView {
      VStack {
        Spacer()
        Text("""
          Please fill up your information to sign up for the service.
          Password must be 6 characters or more. It cannot be 'password'.
          Username must be available (i.e. 'foobar').
        """)
          .padding()
        Form {
          Section {
            HStack {
              TextField("Username", text: $model.username)
                .autocapitalization(.none)
                .textContentType(.nickname)
                .keyboardType(.alphabet)
              Text(usernameAvailable ? "✅" : "❌")
                .onReceive(model.validatedUsername) {
                  self.usernameAvailable = $0 != nil
              }
            }
          }
          Section {
            TextField("Password 'secreto'", text: $model.password)
              .autocapitalization(.none)
              .textContentType(.password)
              .keyboardType(.alphabet)
            HStack {
              TextField("Password again", text: $model.passwordAgain)
                .autocapitalization(.none)
                .textContentType(.password)
                .keyboardType(.alphabet)
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
            //.disabled(validUsername == nil || validPassword == nil)
            //.onReceive(model.validatedCredentials) {
            //  guard let credentials = $0 else {
            //    self.validUsername = nil
            //    self.validPassword = nil
            //    return
            //  }
            //  let (validUsername, validPassword) = credentials
            //  self.validUsername = validUsername
            //  self.validPassword = validPassword == "invalid" ? nil : validPassword
            //}
            //}
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

struct SignUpForm_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SignUpForm()
      SignUpForm(usernameAvailable: true)
    }
  }
}
