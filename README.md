# ChatRoom Application 

This is a chatting app that utilizes Firestore Database to store chat messages and user information. Firebase is used for storing and retrieving images. The app implements push notifications through Firebase Messaging Services and executes event logic using Firebase Cloud Functions. Users can sign up with an image from either the camera or gallery, or login through the authentication screen.

## Features

**Push Notifications**: The app leverages Firebase Messaging Services to implement push notifications. Users receive real-time notifications when they receive new messages, enhancing the messaging experience.

<img src="https://github.com/Ayank-Kumar/Chatting_App/assets/77344547/b467f231-1700-46bd-9974-d287bf5585a3" width="250" height="400">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://github.com/Ayank-Kumar/Chatting_App/assets/77344547/dce6f6a2-90e2-4441-85b0-521ff978a3ba" width="200" height="400">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://github.com/Ayank-Kumar/Chatting_App/assets/77344547/f358bf51-de94-4e3d-8bfc-0f0754bb771d" width="200" height="400">

**Firebase Image Storage**: Images are stored and retrieved using Firebase Storage. This enables users to share and display images within the chat.

**Making Profile**: Users can sign up using an image from either the camera or gallery, providing a personalized profile photo. Alternatively, they can log in using their existing credentials through the authentication screen as shown on the right screen. 

<img src="https://github.com/Ayank-Kumar/Chatting_App/assets/77344547/cecb26fd-1d79-4ccf-ac7b-b49cbbb06108" width="200" height="400"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://github.com/Ayank-Kumar/Chatting_App/assets/77344547/749cbbfa-30bb-4e49-b91b-9eeec46febdf" width="200" height="400">

**Chatroom**: The chatroom interface displays messages from all users in message bubbles, along with their usernames and profile photos. This provides a visually engaging and interactive chat experience. On the right hand side is a pictography of how messages are sent in the application.

<img src="https://github.com/Ayank-Kumar/Chatting_App/assets/77344547/05f98891-1ec7-41d5-96e6-eafacdf443c1" width="200" height="400">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://github.com/Ayank-Kumar/Chatting_App/assets/77344547/1a1eadf9-ce93-4c71-a836-368d2159156a" width="200" height="400">

## Technologies Used

**Firestore Database**: The app utilizes Firestore Database to store chat messages and user information. This allows for real-time synchronization and efficient management of chat conversations.

**Firebase Cloud Functions**: Event logic, such as sending push notifications, is executed using Firebase Cloud Functions. This ensures reliable and scalable handling of backend operations.

## Installation

To install and run the app locally, follow these steps:

1. Clone the repository to your local machine.
2. Install the required dependencies using the package manager of your choice (e.g., `flutter pub get`).
3. Build and run the app on your preferred device or emulator.

## Usage

Once the app is running, users can perform the following actions:

- Sign up with an image from the camera or gallery, or log in using existing credentials.
- View and participate in chat conversations in the chatroom.
- Send and receive messages in real-time.
- Receive push notifications for new messages.
- Enjoy a visually appealing chat experience with user profiles and message bubbles.

Feel free to explore the app's functionality and interact with other users to experience seamless communication.

## License

This project is licensed under the [MIT License](link-to-your-license-file).
