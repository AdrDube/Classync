# ClassSync

<!-- PROJECT LOGO -->

<br />
<div align="center">
  <a href="https://github.com/adrdube/Classync">
    <img src="https://s14.gifyu.com/images/bxpc8.png" alt="Logo" width="150" height="150">
  </a>
  <p align="center">
    Seamless. Secure. Smart Attendance for the Modern Classroom.
    <br />
    <a href="https://drive.google.com/file/d/1SrZVmEqOnvEH3af8J0s7yjYr2p57tWI1/view?usp=share_link"><strong>Watch Demo »</strong></a>
    <br />
    <br />
    &middot;
    <a href="https://github.com/adrdube/Classync/issues/new?labels=bug&template=bug-report.md">Report Bug</a>
    &middot;
    <a href="https://github.com/adrdube/Classync/issues/new?labels=enhancement&template=feature-request.md">Request Feature</a>
  </p>
</div>

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#the-problem">The Problem</a></li>
        <li><a href="#the-solution">The Solution</a></li>
        <li><a href="#technologies-used">Technologies Used</a></li>
        <li><a href="#impact--benefits">Impact & Benefits</a></li>
        <li><a href="#who-benefits">Who Benefits</a></li>
      </ul>
    </li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

---
### Promo

<div align="center">
  <a href="https://drive.google.com/file/d/1SrZVmEqOnvEH3af8J0s7yjYr2p57tWI1/view?usp=share_link">
    <img 
      src="https://s14.gifyu.com/images/bxp4D.gif" 
      height="400" 
      alt="Classync Promo">
  </a>
</div>

### Built With

* ![Swift][swift] ![SwiftUI][swiftui]
* ![Firebase][firebase] ![CoreLocation][corelocation]
* ![Xcode][xcode]

## About The Project

### The Problem

Traditional attendance methods (roll call, sign-in sheets, or scanning IDs) are:

* Time-consuming and disruptive
* Prone to cheating or proxies
* Difficult to audit accurately
* Not inclusive of privacy-first design

### The Solution
<div align="center">
  <a href="https://drive.google.com/file/d/1062mCP05BvNcqWPmuy7CPSeZAjfiqAdv/view?usp=share_link">
    <img 
      src="https://raw.githubusercontent.com/AdrDube/adrdube/main/.github/workflows/ClassSync-short.gif" 
      height="400" 
      alt="Classync Demo">
  </a>
</div>

ClassSync transforms the attendance process through:

* 📍 **Proximity Detection via Nearby Interaction** – Automatically marks present when students are within range.
* 🔐 **Secure Auth via Firebase & FaceID** – Ensures the right student is always accounted for.
* 📊 **Live Student Dashboards** – Real-time visibility into attendance stats.
* 🎨 **Elegant, Accessible UI** – Built with SwiftUI for fluid and accessible design.
* 📱 **iOS Native** – Uses Apple ecosystem tools for performance and security.

## Technologies Used

* **Languages & Frameworks:** Swift, SwiftUI, Firebase, Combine
* **Architecture:** MVVM (Model-View-ViewModel)
* **APIs:** CoreLocation, Nearby Interaction, Firebase Auth
* **Tools:** Xcode, Firebase Console

## Impact & Benefits

* ⏱️ **Time Savings:** Instructors save hours weekly with automated roll calls
* 🔒 **Data Integrity:** Prevents proxy attendance, ensuring fairness
* 📈 **Transparency:** Dashboards empower students to track their own attendance
* 📡 **Smart Use of Tech:** Minimal location access + secure storage of user data

## Who Benefits

* **Students**: No need to remember to sign-in or scan
* **Faculty**: Reduces manual tasks and errors
* **Administrators**: Improved audit trails and engagement tracking

## Roadmap

* [x] Nearby Interaction-based presence tracking
* [x] FaceID + Firebase login
* [x] Real-time attendance dashboard
* [ ] Instructor view for live class roster
* [ ] Push notification reminders for check-in windows

---

## Contributing

Want to enhance ClassSync or pilot it at your institution?

* Fork the repo
* Create your branch (`git checkout -b feature/YourFeature`)
* Commit your changes (`git commit -m 'Add new feature'`)
* Push to the branch (`git push origin feature/YourFeature`)
* Open a Pull Request

## Contact

### Adriel Dube

<div align="left">
  <a href="mailto:adrtdube@gmail.com" target="_blank">
    <img src="https://img.shields.io/static/v1?message=Gmail&logo=gmail&label=&color=D14836&logoColor=white&labelColor=&style=for-the-badge" height="35" alt="gmail logo" hspace="10"/>
  </a>
  <a href="https://www.linkedin.com/in/adrieltdube/" target="_blank">
    <img src="https://img.shields.io/static/v1?message=LinkedIn&logo=linkedin&label=&color=0077B5&logoColor=white&labelColor=&style=for-the-badge" height="35" alt="linkedin logo" hspace="10" />
  </a>
  <a href="https://adrdube.github.io/" target="_blank">
    <img src="https://imgur.com/aQG90R1.png" height="35"  width="120" alt="website portfolio" hspace="10"/>
  </a>
</div>

## License

Distributed under the Unlicense. See `LICENSE` for more information.

---

## Acknowledgments

* [SwiftUI Docs](https://developer.apple.com/documentation/swiftui/)
* [Firebase Docs](https://firebase.google.com/docs)
* [Nearby Interaction](https://developer.apple.com/documentation/nearbyinteraction/)
* [Hacking with Swift](https://www.hackingwithswift.com/)

<!-- Badge Links -->

[swift]: https://img.shields.io/badge/Swift-FA7343.svg?style=for-the-badge&logo=swift&logoColor=white
[firebase]: https://img.shields.io/badge/Firebase-FFCA28.svg?style=for-the-badge&logo=firebase&logoColor=white
[xcode]: https://img.shields.io/badge/Xcode-147EFB.svg?style=for-the-badge&logo=xcode&logoColor=white
[swiftui]: https://img.shields.io/badge/SwiftUI-000000.svg?style=for-the-badge&logo=swift&logoColor=white
[corelocation]: https://img.shields.io/badge/CoreLocation-4285F4.svg?style=for-the-badge&logo=apple&logoColor=white
[mvvm]: https://img.shields.io/badge/MVVM-007ACC.svg?style=for-the-badge&logo=visualstudiocode&logoColor=white
