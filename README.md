# FINAL PROJECT  program description, installation guide, and how to use the
app.

**Name:** Denisse Alcantara <br/>
**Section:** U-2L <br/>
**Student number:** 2022 - 11877 <br/>

## Program Description

    This Flutter application serves as a Digital Slambook, allowing users to add, view, and manage their friends details. They can also personalize their profile. Each user can manually add a friend using the Slambook, or add them through a generated QR code by their friend. Users can also generate their own QR codes to be used by their friends, and all data are managed using Firebase Firestore.

    Features: 
    Sign in and Sign up: Users needs to sign in first before accesing the Slambook Page. If the user has not yet made an account, the user can make one using the Sign up option.
    Slambook Form: Users can fill out a form with their friends' name, nickname, age, relationship status, happiness level, motto, and superpower.
    Profile Management: Each user has a profile page where they can view and edit their Profile details.
    Friends Management: Users can add friends by scanning QR codes or manually entering details in the Slambook. Each user's friends list is specific to their account.
    Firebase Integration: All data, including user profiles and friends, are stored in Firestore, ensuring data is persistent and secure.


## Installation Guide

    For Android (only):
        - Connect your device to where the program is located with the compatible USB you have.
        - Open you settings and go to Developer Option
        - Turn on your device's Developer Option 
        - Or go to About Phone and tap the build number multiple times until it enables your Developer Option
        - Go back to flutter and type in the command line "Flutter run"

## How to use the app 
    Sign in 
            - Sign in first to access your Slambook
            - If you haven't had an account yet, you can make one using the Sign up option.     
    
    Friends Page
        - This will show the list of all your friends with their Name and nickname as preview
        - There is a "View Details" button to view your friend's detials 
        - An "Edit" icon enables you to edit your friend's details (except for their name)
        - The "Delete" button allows you to delete that friend
    
    Profile Page
        - The Profile Page allows you to enter your details like in the Slambook
        - There is a Floating Button on the lower right of the screen that generates a QR Code that lets others to add you as their friend

    Slambook Page
        - You can manually add your friend through filling the Slambook form up
        - But you can also add them through a QR code when you tap the Floating Button on the lower right of the screen 

    On the upper right hand corner, there are three buttons (from left to right)
        - Profile Page
        - Slambook Page
        - Friends Page    

## References

- [https://helloyogita.medium.com/dart-programming-triple-dot-spread-operator-f57fa39e12b0#:~:text=The%20spread%20operator%20is%20three,to%20add%20to%20our%20list.)] for putting a list inside a list
- [https://stackoverflow.com/questions/44490622/disable-a-text-edit-field-in-flutter)] for disabling the TextFormField
- [https://api.dart.dev/stable/2.16.2/dart-core/List/removeWhere.html] for the removeWhere() and indexWhere() methods for the lists