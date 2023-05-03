//
//  SettingsView.swift
//  SwiftAuthentification
//
//  Created by Caleb Mawji on 2023-05-03.
//

import SwiftUI

@MainActor
final class SettingViewModel: ObservableObject
{
    func signOut() throws
    {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws
    {
        let authUser=try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email
                else
        {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.reserPassword(email: email)
    }
}
struct SettingsView: View {
    @StateObject private var viewModel = SettingViewModel()
    @Binding var showingSignInView: Bool
    var body: some View {
        List {
            Button("Quitter")
            {
                Task
                {
                    do{
                        try viewModel.signOut()
                        showingSignInView = true
                    }catch
                    {
                        print(error)
                    }
                }
            }
            Button("Changer mot de passe")
            {
                Task
                {
                    do{
                        try await viewModel.resetPassword()
                        print("Mot de passe envoyé")
                    }catch
                    {
                        print(error)
                    }
                }
            }
        }
        .navigationBarTitle("Paramètres")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showingSignInView: .constant(false))
    }
}
