# Study Planner App

A comprehensive Flutter application for managing study tasks with calendar integration, reminders, and local storage options.

## Features

### 1. Task Management
- Create tasks with title (required) and description (optional)
- Set due dates with date and time selection
- Configure reminder notifications (1 day before / 1 hour before)
- View today's tasks on a dedicated screen
- Delete tasks from the calendar view
- Visual notification time display when reminders are set

### 2. Calendar View
- Monthly calendar display with all dates
- Visual highlighting of dates with scheduled tasks
- Tap any date to view tasks for that specific day
- Task list shows title, description, and due time
- Quick task deletion from calendar view

### 3. Reminder System
- Set reminders for 1 day before task due date
- Set reminders for 1 hour before task due date
- Pop-up alerts when app is opened (within 10 minutes of task)
- Notification history screen showing all reminder activities
- Toggle reminders on/off from settings

### 4. Local Storage
- **Dual storage options:**
  - JSON storage using SharedPreferences (default)
  - SQLite database storage
- Switch between storage methods in Settings
- Automatic data migration when switching storage types
- Data persists after app closure

### 5. Navigation Structure
- Bottom Navigation Bar with three main screens:
  - **Today**: Shows tasks due today
  - **Calendar**: Monthly calendar with task integration
  - **Settings**: App configuration and storage options
- Additional screens:
  - **New Task**: Form for creating new tasks
  - **Notifications**: History of all notification events

## Project Structure

```
lib/
├── main.dart                 # Main application file with all screens
├── models/
│   └── task.dart            # Task data model
├── services/
│   ├── storage_service.dart # Storage interface
│   ├── json_storage.dart    # JSON storage implementation
│   └── sqlite_storage.dart  # SQLite storage implementation
├── providers/
│   └── task_provider.dart   # State management for tasks
├── screens/
│   ├── today_screen.dart    # Today's tasks view
│   ├── calendar_screen.dart # Calendar with tasks
│   ├── settings_screen.dart # App settings
│   ├── new_task_screen.dart # Task creation form
│   └── notifications_screen.dart # Notification history
└── widgets/
    └── (custom widgets if needed)
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Android Emulator or Physical Device

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/yourusername/study_planner.git
cd study_planner
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Run the app:**
```bash
flutter run
```

### Building for Release

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## Code Architecture

### Storage Layer
The app implements a **Strategy Pattern** for storage:
- `StorageService`: Abstract interface defining storage operations
- `JsonStorageService`: Implements storage using SharedPreferences
- `SqliteStorageService`: Implements storage using SQLite database

### State Management
- Uses `TaskProvider` class for centralized state management
- Manages task CRUD operations
- Handles reminder scheduling and checks
- Provides storage type switching

### UI Design
- **Color Scheme:**
  - Background: #031438 (Dark blue)
  - Accent: #FAC606 (Yellow/Gold)
  - Text: White with various opacity levels
- **Material Design** principles followed throughout
- Consistent border radius (10px) for containers
- Clean, minimalist interface

## Key Widgets Used

### Core Flutter Widgets
- `Scaffold`: Basic page structure
- `AppBar`: Top navigation bar
- `BottomNavigationBar`: Main navigation
- `Container`: Layout and styling
- `Column` / `Row`: Layout arrangement
- `ListView` / `ListTile`: List displays
- `TextField`: Text input
- `ElevatedButton`: Action buttons
- `Radio`: Selection options
- `Switch`: Toggle controls

### External Packages
- `TableCalendar`: Monthly calendar widget
- `showDatePicker` / `showTimePicker`: Date/time selection
- `AlertDialog`: Reminder popups

## Features Implementation Details

### Task Creation Flow
1. User taps "New Task" button on Today screen
2. Navigates to New Task form
3. Fills in required fields (title, date)
4. Optional: Sets reminders (1 day/1 hour before)
5. Visual feedback shows notification time when reminder selected
6. Save button stores task to selected storage method

### Storage Migration
When switching storage types:
1. Load all tasks from current storage
2. Initialize new storage service
3. Transfer all tasks to new storage
4. Update provider with new storage reference
5. Show confirmation to user

### Reminder System
- Timer runs every minute checking for due reminders
- Checks three conditions:
  - 1 day before notification
  - 1 hour before notification
  - Within 10 minutes of task due time
- Shows AlertDialog when conditions met
- Can be disabled via Settings toggle

## Testing Checklist

### Functional Requirements
- [ ] Create task with all fields
- [ ] View today's tasks
- [ ] Navigate calendar and view tasks by date
- [ ] Set and receive reminders
- [ ] Delete tasks
- [ ] Switch storage methods
- [ ] Data persists after app restart

### Non-Functional Requirements
- [ ] Clean Material Design UI
- [ ] Smooth navigation between screens
- [ ] Consistent color scheme
- [ ] Works in portrait/landscape orientation
- [ ] No data loss on app closure

## Rubric Compliance

### Code Quality & Documentation (7 pts)
- Well-structured code with separation of concerns
- Meaningful variable and function names
- Comprehensive comments throughout
- Complete README documentation

### Video Demo Requirements (5 pts)
- Show initial empty state
- Demonstrate code implementation
- Explain line-by-line functionality
- Use correct Flutter terminology
- Show running results for each feature

### Core Features (5 pts)
- Task creation with all fields
- Today's task display
- Calendar integration with highlighting
- Reminder popup functionality

### Navigation (4 pts)
- BottomNavigationBar implementation
- Three main screens (Today, Calendar, Settings)
- Screen switching logic
- Consistent navigation flow

### UI/UX Design (4 pts)
- Material Design compliance
- Clean, consistent layout
- Proper widget usage
- Visual feedback for user actions

### Storage Implementation (5 pts)
- Data persistence after restart
- Storage method selection
- Save/load functionality
- Data migration between storage types

## Demo Video Script Outline

1. **Introduction** (30 seconds)
   - App overview and purpose
   - Technologies used

2. **Code Structure** (2 minutes)
   - Project organization
   - Key files and their purposes
   - Storage pattern implementation

3. **Feature Demonstrations** (5-7 minutes)
   - Create new task (show code + demo)
   - View today's tasks
   - Calendar navigation
   - Reminder system
   - Storage switching
   - Data persistence

4. **Technical Highlights** (1-2 minutes)
   - State management approach
   - Storage abstraction
   - UI/UX considerations

## Troubleshooting

### Common Issues

**Issue: Tasks not persisting**
- Solution: Check storage permissions in AndroidManifest.xml

**Issue: Calendar not displaying**
- Solution: Ensure table_calendar package is properly installed

**Issue: Reminders not working**
- Solution: Verify reminder toggle is enabled in Settings

## Future Enhancements
- Push notifications (using flutter_local_notifications)
- Task categories/tags
- Task priority levels
- Dark/Light theme toggle
- Export tasks to CSV/PDF
- Cloud backup integration
- Task completion tracking
- Study statistics dashboard

## License
This project is created for educational purposes as part of a Flutter development course.

