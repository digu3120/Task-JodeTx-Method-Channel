Steps To Run the Project


🛠️ Prerequisites
•	Flutter (3.x or higher)
•	Android Studio or VS Code
•	Android SDK
•	Java 11 or 17 (for Gradle compatibility)

✅ Step-by-Step Instructions

🔹 Step 1: Prepare Host App to Consume AAR

Download Project from GitHub Repo :

git clone https://github.com/digu3120/Task-JodeTx-Method-Channel.git

- cd flutter_aar_module

- flutter build aar

-----flutter_aar_module/build/host/outputs/repo/


🔹 Step 2: Prepare Host App to Consume AAR

cd ../host_flutter_app
flutter pub get
flutter run

🧪 Verifying Two-Way Communication
Once the host app is running, use the UI:
•	✅ Send a message from AAR (Jodetx) to host (Digu) — input box
•	✅ Host validates the origin ([JODETX_ORIGIN]) and displays a response
•	✅ Host can also send a reply to AAR (visible in console)

Clean Build (optional)
If builds are failing, you can reset:
cd flutter_aar_module
flutter clean
flutter pub get
flutter build aar

cd ../host_flutter_app
flutter clean
flutter pub get
flutter run


