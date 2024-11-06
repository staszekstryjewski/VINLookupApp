# VIN Search Challenge - Summary

## Objective
This VINLookup app enables users to search for vehicle information by entering a VIN number, fetching data from the Ninjas VIN Lookup API, and displaying details. It supports recent searches storage, input validation, rate limiting, error handling, and an extra feature for VIN recognition from images.

---

## Project Overview

The app validates VIN input, retrieves vehicle details via the Ninjas API, and presents key details (WMI, VDS, VIS, country, region, year) in an overlay. A recent searches list offers quick access to past lookups, with a modular architecture that facilitates scalability and maintenance.
The app is tested on iPhones ranging from SE to Pro Max, supports both light and dark mode, and is limited to portrait orientation only.

---

## Key Features and Implementation Details

### 1. Architecture and Design
- **MVVM with SwiftUI**: Implements **Model-View-ViewModel (MVVM)** architecture for clear separation of UI and logic. Each main view has a ViewModel, enhancing modularity, testability, and maintainability.
- **Composition Layer with ViewFactory**: A `ViewFactory` serves as the composition layer, assembling views and dependencies to promote reusability and streamline view creation.

### 2. Input Validation
- **Validator Protocol**: The app uses a `Validator` protocol to validate input types. This approach allows custom implementations for various validation rules, making the input field flexible and reusable.
- **VIN Validation**: The VIN input field uses the `Validator` protocol to validate VIN format before initiating a lookup.

### 3. API Integration and Networking
- **LookupService**: `LookupService` manages networking with asynchronous requests, caching, and loading states, implemented as an `actor`.
- **Rate Limiting**: `LookupService` handles the API’s rate limit (10 requests/min) with a retry mechanism using exponential backoff. Catches `rateLimitExceeded` errors and retries up to 3 times with incremental delays.
- **Image-to-Text Recognition**: VIN recognition from images is integrated into `LookupService` behind a protocol for consistency, sharing a modular structure with other network tasks.

### 4. Data Storage
- **Persistent Storage**: Recent searches are stored in JSON format, encapsulated in a `Storage` protocol for flexibility, allowing easy future improvements in storage technology.

### 5. UI/UX Design
- **SwiftUI Components**: The UI is built with SwiftUI components, prioritizing simplicity. Key screens include:
  - **VIN Input Screen**: A text input with validation and a search button.
  - **Vehicle Information Overlay**: Displays fetched vehicle data in a modal.
  - **Recent Searches List**: Shows past VIN searches for quick reference.
  - **Image-To-Text Screen**: Allows VIN extraction from a photo.
  - **Error and Loading States**: User-friendly loading indicators and error messages enhance UX.

---

## Testing

### 1. Unit Testing
- **Test Coverage**: Unit tests cover most **ViewModels** and core services, ensuring functionality across key components.
- **New Swift Testing Framework**: Used the new Swift testing framework, offering insights into its usage and benefits.

### 2. Areas for Improvement
- **ValidatedInput Component**: Could be refactored for better testability.
- **Image-to-Text ViewModel**: Refactoring needed to improve testability.

---

## Challenges and Solutions

### 1. Increased Scope
Initial scope underestimated, especially with the **bonus** image-to-text task. Consolidated components to minimize complexity.

### 2. Reusable Validation Component
Designed the `Validator` protocol-based input to be flexible and context-agnostic, enhancing reusability.

### 3. Learning Curve with New Testing Framework
Faced a learning curve with the new Swift testing framework, gaining valuable insights.

### 4. Testing Challenges
Some components presented testing challenges, marking areas for potential refactoring and improvement.

---

## Future Enhancements

- **Improved Storage Solution**: Consider migrating from JSON to **Core Data** or other database solutions for scalability.
- **Enhanced Error Handling**: Additional handling for network issues and timeout errors to improve UX.
- **Barcode Scanning Support**: Integrate barcode scanning to streamline VIN input, reducing manual entry errors.
- **Expanded Test Coverage**: Increase test coverage for `ValidatedInput`, image-to-text ViewModel, and `LookupService`.
- **Localization**: Prepare the app for multiple languages and region-specific formats.
- **Accessibility**: Add VoiceOver support, dynamic type scaling, and improve readability for assistive tech users.
- **Camera Integration**: Enable image capture directly from the camera, enhancing VIN entry convenience.
- **Enhanced Image-to-Text Validation**: Implement validation for text extracted from images, improving accuracy and user confidence.
- **More Store Functionality**: Implement functions to remove individual recent searches or clear all recent searches, giving users control over their search history.

---

## Conclusion

The app is a modular, organized solution that meets challenge requirements, emphasizing clean architecture, reusability, and user experience. Leveraging SwiftUI, MVVM, and protocol-based abstractions aligns with modern iOS development practices, ensuring the codebase is maintainable and adaptable to future needs.
