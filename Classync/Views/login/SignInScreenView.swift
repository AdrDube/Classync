//
//  SignInScreenView.swift
//  login
//
//  Created by Abu Anwar MD Abdullah on 23/4/21.
//

import SwiftUI

struct SignInScreenView: View {
    @State private var email: String = "" // by default it's empty
    @State private var password: String = ""
    @State private var isHovered = false
    @State private var navigateToDashboard = false
    @Binding var loggedIn : Bool
    //@State private var text: String = ""
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color("BgColor").edgesIgnoringSafeArea(.all)
                VStack(spacing: 10) {
                    Spacer()
                    Spacer()
                    Image(uiImage: #imageLiteral(resourceName: "grambling-logo.png"))
                    
                    VStack {
                        Text("Sign In")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 20.0)
                            .foregroundColor(.black)
                        
                        
                        TextField("", text: $email)
                            .placeholderStyle("Enter your email", color: .gray, show: email.isEmpty)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                            
                            .padding(.top, 20)
                            .foregroundColor(.black)
                         
                        SecureField("", text: $password)
                            .placeholderStyle("Password", color: .gray, show: password.isEmpty)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                            .padding(.top, 20)
                            .foregroundColor(.black)
                        
                        
                        Button(action: {
                            let users = LocalStorage.loadUsers()
                            
                            if let user = users.first(where: { $0.email == email && $0.password == password }) {
                                print("Login successful: Welcome \(user.firstName)")
                                loggedIn = true

                                
                            }
                            else {
                                print("Invalid email or password")
                                
                            }
                        }) {
                            Text("Sign In")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("PrimaryColor"))
                                .foregroundColor(.white)
                                .cornerRadius(50)
                                .padding(.top,25)
                                
                            
                        }
                        
                        
                        HStack {
                            Text("New around here?")
                                .foregroundColor(Color.black)
                                .padding(.top, 20)
                            
                            NavigationLink(destination: SignUpView(loggedIn: $loggedIn)) {
                                Text("Sign Up")
                                    .foregroundColor(isHovered ? .black : .blue)
                                    .onHover { hovering in isHovered = hovering}
                                
                                    .padding(.top, 20)
                            }
                        }
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                }
                .padding()
            }
        }
    }
    struct SignUpView_Previews: PreviewProvider {
        static var previews: some View {
            struct PreviewWrapper: View {
                @State private var loggedIn = false
                
                var body: some View {
                    SignUpView(loggedIn: $loggedIn)
                }
            }
            return PreviewWrapper()
        }
    }
    
}

struct PrimaryButton: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("PrimaryColor"))
            .cornerRadius(50)
    }
}


