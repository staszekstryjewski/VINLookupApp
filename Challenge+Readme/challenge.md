# Mobile App Coding Challenge: VIN Search Challenge

## Overview
Solve the **VIN Search Challenge** at home, dedicating as much time and effort as you wish.  

The completed challenge should be:
- A buildable project in **Xcode**
- Written in **Swift**, preferably using **SwiftUI** for the presentation layer.

---

## VIN Search Challenge

### Requirements

### 1. VIN Input Screen
- A main screen with:
  - Input field for the VIN number
  - A **Search** button
- Input must be validated **before** making an API request.
- Additional input methods (beyond text input) can be added if useful.

### 2. Vehicle Information Screen
- Present received information on a **modal or overlay screen**.
- The modal/overlay should be easy to close.
- Display the following details:
  - **Title**: VIN
  - **Details**: 
    - `wmi`
    - `vds`
    - `vis`
    - `country`
    - `region`
    - `year`

### 3. Recent Searches List
- Include a list of recent VIN searches for user convenience.
- Allow the user to select a recent VIN search for reuse.

---

## Additional Requirements
- **Reusable Input Field and Lookup Feature**:
  - Make the input field and vehicle lookup feature generic and reusable in other apps.
- **Rate Limiting**:
  - Assume a rate limit of **10 requests per minute**.
- **Error Handling**:
  - Prepare the app to handle long loading times and potential API errors.

---

## Public API
- Use the **Ninjas API**: [VIN Lookup API Documentation](https://api-ninjas.com/api/vinlookup).
- Authentication: Use the provided header `[YOUR HEADER HERE]`.
- **Sample VIN Numbers**:
  - `JT3HP10VXW7092383`
  - `4TARN13P1SZ314855`
  - `JTDKN3DU6C1423122`
  - `KMHDN45D32D464848`

---

## Evaluation Guidelines

### Functional Requirements
1. **Implementation**:
   - Success and error handling paths
   - Input validation
   - Rate-limiting handling
   - Recent searches functionality
   - Additional input methods (if implemented)

### Code Readability and Quality
2. **Best Practices**:
   - Clear architecture
   - Adherence to SOLID principles
   - Consistent naming conventions
   - Testability of components

### Modularization
3. **Reusability**:
   - Input field and VIN lookup feature should be modular and easily reusable.

### Overall Solution Quality
4. **Evaluation**:
   - Simplicity and clarity
   - Use of platform built-in components
   - Smooth user experience (UX)

---

## How to Share
- Submit your solution via **GitHub**.
