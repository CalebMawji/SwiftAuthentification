//
//  SignInEmailView.swift
//  SwiftAuthentification
//
//  Created by Caleb Mawji on 2023-05-01.
//

import SwiftUI

@MainActor
final class SignInViewModel: ObservableObject {
    @Published var name = ""
    @Published var age = ""
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        guard !name.isEmpty, !age.isEmpty, !email.isEmpty, !password.isEmpty else {
            print("Please fill in all fields.")
            return
        }
        
        let returnedUserData = try await AuthenticationManager.shared.signInUser(name: name, age: age, email: email, password: password)
        print("User signed in")
        print(returnedUserData)
    }
    
    func signUp() async throws {
        guard !name.isEmpty, !age.isEmpty, !email.isEmpty, !password.isEmpty else {
            print("Please fill in all fields.")
            return
        }
        
        let returnedUserData = try await AuthenticationManager.shared.createUser(name: name, age: age, email: email, password: password)
        print("User created")
        print(returnedUserData)
    }
}

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            TextField("Name", text: $viewModel.name)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            TextField("Age", text: $viewModel.age)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            TextField("Email", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInView(showSignInView: .constant(false))
        }
    }
}
