import Foundation
import Combine

func usernameAvailable(_ username: String, completion: @escaping (Bool) -> ()) -> () {
  DispatchQueue.main .async {
    if (username == "foobar") {
      completion(true)
    } else {
      completion(false)
    }
  }
}

class SignUpFormModel: ObservableObject {
  
  @Published var username: String = ""
  @Published var password: String = ""
  @Published var passwordAgain: String = ""
  
  var validatedPassword: AnyPublisher<String?, Never> {
    $password.combineLatest($passwordAgain) { password, passwordAgain in
      guard password == passwordAgain, password.count > 6 else {
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
