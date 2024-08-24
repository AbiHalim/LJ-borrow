# LJ Borrow

## Overview

LJ Borrow is an iOS application designed to help users track and manage money borrowed and lent between friends and family. The app ensures that users can record, confirm, and remind each other about financial transactions to avoid conflicts and ensure accurate record-keeping.

## Features

- **Account Management:** Create, register, and log in to your account.
- **Record Creation:** Add records of borrowed or lent money with details and notes.
- **Record Confirmation:** Confirm or reject records created by others.
- **Reminders:** Automatic reminders for unpaid records and manual reminder notifications.
- **Profile Management:** View and manage your profile and log out.

## Tech Stack

- **Back-end:** Python with Flask
- **Database:** SQLite
- **Front-end:** Swift
- **Version Control:** GitHub
- **UI Design:** Figma
- **Unit Testing:** Postman

## Setup Instructions

1. **Download and Extract:**
   - Download the project ZIP file.
   - Extract the contents.

2. **Environment Setup:**
   - **Python:** Install necessary Python packages:
     ```bash
     pip install sqlite3 flask itsdangerous functools
     ```
   - **iOS Development:** Download and install Xcode.

3. **Running the Application:**
   - Open the project folder in Xcode and your Python IDE.
   - **Backend:**
     - Open `main.py` in your Python IDE.
     - Move the line `app.run(host='0.0.0.0', port=5000)` to the bottom of the file to create tables, then run `main.py`.
   - **Frontend:**
     - Open `MainView` in Xcode.
     - Select `iPhone 15 Pro Max` as the run destination.
     - Press `Command + R` to run the simulator.

## User Stories

- Create and manage records of money transactions.
- Confirm and view records.
- Receive and send reminders.

## Backend Details

- **Database:** SQLite with tables for users and records.
- **RESTful API:** Endpoints set up in Flask for interaction with the frontend.

## Additional Resources

For detailed documentation, deployment instructions, and more, please refer to the [full documentation]](https://docs.google.com/document/d/11xayTXj0tiXJqWw_js_8mQDMlyUPW--r8hPQSfYoJDQ/edit)..
