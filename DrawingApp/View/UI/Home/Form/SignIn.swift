//
//  SignIn.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/07/14.
//

import SwiftUI

struct SignIn: View {
    @State private var username: String = ""
    @State private var pwd = ""
    @State private var shouldAutoLog = false
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        GeometryReader { geometry in
            // NavigationView {
                ScrollView(showsIndicators: false) {
                    VStack {
                        Image("logo_digidog")
                            .resizable()
                            .padding(.all, 20)
                            .frame(maxWidth: 300, maxHeight: 200)
                            .aspectRatio(1.3, contentMode: .fill)
                            .padding(.bottom, 30)
                            // .frame(maxWidth: .infinity)
                        
                        
                        TextField("아이디 입력", text: $username)
                            .padding()
                            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                                
                        
                        TextField("비밀번호 입력 (8~15자리 영문+숫자+특수문자 조합)", text: $pwd)
                            .padding()
                            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                        
                        HStack {
                            
                            // Check box
                            Button(action: {
                            },
                                   label: {Text("자동로그인")
                            }
                            )
                            
                            Spacer()
                            
                            Button(action: {
                            },
                                   label: {Text("아이디/비밀번호 찾기")}
                            )
                            
                        }
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                        .font(.caption)
                        .padding([.top, .bottom], 20)
                        
                        NavigationLink (destination: UserHomeView()) {
                            Text("로그인")
                                .frame(maxWidth: .infinity)
                                .padding(.all, 15)
                                .background(Color.black)
                                .foregroundColor(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            /*
                            Button(action: {
                            },
                                   label: {
                                        Text("로그인")
                                    .frame(maxWidth: .infinity)
                                    .padding(.all, 15)
                                    .background(Color.black)
                                    .foregroundColor(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                            )
                             */
                        }

                        
                        // Horizontal diver
                    
                        Divider()
                            .padding(.vertical, 25)
                            
                        
                        Text("SNS계정으로 간편 로그인/회원가입")
                            .padding(.bottom, 25)
                            .font(Font.system(.callout))
                        
                        // Naver login
                        SNSLoginButton(image: Image("icon_naver"), text: "네이버 로그인", action: modelData.naverLogin)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color(red: 0.45, green: 0.73, blue: 0.12), lineWidth: 2)
                            )
                        
                        // Kakao login
                        SNSLoginButton(image: Image("icon_kakao"), text: "카카오 로그인", action: modelData.kakaoLogin)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color(red: 0.96, green: 0.79, blue: 0.05), lineWidth: 2)
                            )
                        
                        Text("SNS 로그인은 개인정보보호를 위해 개인 PC에서만 사용해주세요")
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                            .font(Font.system(.caption))

                    }.frame(maxWidth: 500)
                }
                .padding(.all, 30)
                .frame(minWidth: geometry.size.width)
            // }.navigationViewStyle(.stack)
        }
            
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
