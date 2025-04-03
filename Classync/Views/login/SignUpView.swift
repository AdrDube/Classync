//
//  SignUpView.swift
//  login
//
//  Created by Njabulo Moyo on 3/29/25.
//

import SwiftUI

struct SignUpView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var gNumber: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert = false
    @State private var navigateToSignIn = false
    @State private var errorMessage: String? = nil
    @Binding var loggedIn : Bool
        
    var body: some View {
        ScrollView {
            NavigationStack {
                ZStack {
                    Color("BgColor").edgesIgnoringSafeArea(.all)
                    VStack(spacing: 10) {
                        Color("BgColor").edgesIgnoringSafeArea(.all)
                        Text("Sign Up")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 20.0)
                            .foregroundColor(.black)
                        Spacer()
                        Spacer()
                        
                        TextField("", text: $firstName)
                            .placeholderStyle("First Name", color: .gray, show: firstName.isEmpty)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                            .padding(10)
                            .foregroundColor(.black)
                        Spacer()
                        
                        TextField("", text: $lastName)
                            .placeholderStyle("Last Name", color: .gray, show: lastName.isEmpty)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                            .padding(10)
                            .foregroundColor(.black)
                        Spacer()
                        
                        TextField("", text: $gNumber)
                            .placeholderStyle("G-Number", color: .gray, show: gNumber.isEmpty)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                            .padding(10)
                            .foregroundColor(.black)
                        Spacer()
                        
                        TextField("",text: $email)
                            .placeholderStyle("School email address", color: .gray, show: email.isEmpty)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                            .padding(10)
                            .foregroundColor(.black)
                        Spacer()
                        
                        SecureField("",text: $password)
                            .placeholderStyle("Password", color: .gray, show: password.isEmpty)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                            .padding(.top,5)
                            .padding(8)
                            .foregroundColor(.black)
                        Spacer()
                        
                        SecureField("",text: $confirmPassword)
                            .placeholderStyle("Confirm Password", color: .gray, show: confirmPassword.isEmpty)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                            .padding(.top,5)
                            .padding(8)
                            .foregroundColor(.black)
                        Spacer()
                        
                        Button(action: {
                            errorMessage = nil
                            
                            if firstName.isEmpty ||
                                lastName.isEmpty ||
                                gNumber.isEmpty ||
                                email.isEmpty ||
                                password.isEmpty ||
                                confirmPassword.isEmpty {
                                errorMessage = "Please fill in all fields."
                            } else if password != confirmPassword {
                                errorMessage = "Passwords do not match."
                            } else {
                                var users = LocalStorage.loadUsers()
                                
                                
                                if users.contains(where: { $0.email == email }) {
                                    errorMessage = "Email is already registered."
                                } else {
                                    let newUser = User(firstName: firstName, lastName: lastName, gNumber: gNumber, email: email, password: password)
                                    users.append(newUser)
                                    LocalStorage.saveUsers(users)
                                    
                                    showAlert = true
                                }
                            }
                        }) {
                            Text("Sign Up")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("PrimaryColor"))
                                .foregroundColor(.white)
                                .cornerRadius(50)
                                .padding(8)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Success"),
                                message: Text("Your account has been created!"),
                                dismissButton: .default(Text("OK"), action: {
                                    navigateToSignIn = true
                                })
                            )
                            
                        }
                        .navigationDestination(isPresented: $navigateToSignIn) {
                            SignInScreenView(loggedIn: $loggedIn)
                        }
                        Spacer()
                        Spacer()
                        Spacer()
                        
                    }
                }
            }
        }
            }
        }
    


/*
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
*/
