# FarmDirect
Farm Direct is an online platform designed to connect Canadian farmers directly with consumers, addressing the challenges of distribution, high operational costs, and limited market visibility. This application allows small and medium-sized farmers to create profiles, list their products, and engage with customers through a user-friendly interface.

## Directory Structure
The dart files for the screens are in the "lib" directory.
The Docs directory contains documentation for the project including SRS and SDS documents.

## Screens and Navigation Flow

### 1. ConsumerHomeScreen
Purpose:
Serves as the main landing page for consumers after logging in. This screen displays categories of products (e.g., "Vegetables," "Fruits") that consumers can browse. Each category is represented in a card/grid format.

Key Widgets:
AppBar: Displays the app's title or "Welcome" message.
GridView or ListView: Displays categories in a structured layout, each as a tappable card.
Card: Wraps each category item with an icon or image representing the category and a label.
GestureDetector: Enables tap functionality on each card to navigate to the ProductCategoryScreen with the selected category.

User Interaction:
User selects a category from the grid or list.
Upon tapping a category, the app navigates to ProductCategoryScreen to show products within that category.

### 2. ProductCategoryScreen
Purpose:
Displays specific products within the selected category from ConsumerHomeScreen. For example, if the user selects "Vegetables," this screen will display individual vegetable items like "Tomato," "Carrot," etc.

Key Widgets:
AppBar: Displays the selected category name.
ListView or GridView: Displays individual products within the category in card format.
Card: Each product card includes a product image, name, and other relevant information.
GestureDetector: Allows users to tap on a product card to view the list of farmers who offer that product.

User Interaction:
User taps a specific product (e.g., "Tomato").
This action navigates to FarmerListScreen, showing farmers who have posted produce for the selected product.

### 3. FarmerListScreen
Purpose:
Lists all farmers offering the selected product, displaying details such as each farmer’s name, location, rate, and an image of the produce.

Key Widgets:
AppBar: Displays the product name and includes a filter icon to sort or filter the list.
Search Box: Allows users to search for farmers by name or location.
ListView: Displays each farmer’s information in a horizontal card format.
Card (FarmerCard): Shows details for each farmer (e.g., image, name, location, rate).
IconButton: Displays filter options (e.g., price sorting) when tapped.

User Interaction:
User can search or filter farmers by price, name, or location.
Tapping on a farmer card navigates to ProductDetailScreen to view full details of the selected farmer’s product.

### 4. ProductDetailScreen
Purpose:
Displays detailed information about the selected farmer's product, including product images, the farmer's contact details, available quantity, price, posting date, and delivery option.

Key Widgets:
AppBar: Displays the product or farmer name.
Image Carousel: Shows multiple images of the product if available.
Text Widgets: Display details like quantity, price, posting date, delivery options, and contact information.
ListTile or Column: Organizes product and farmer details for easy readability.

User Interaction:
User views comprehensive details about the product and the farmer.
User can decide to contact the farmer based on the information provided.

### 5. SignupScreen
Purpose:
Enables new users to create an account by providing details such as first name, last name, user type (farmer or consumer), phone number, and an optional email address. Also includes an OTP verification for phone number validation.

Key Widgets:
Form: Wraps all input fields and handles validation.
TextFormField: Accepts inputs for name, phone number, and optional email.
Radio Buttons: Lets users choose their role (Farmer or Consumer).
ElevatedButton: Sends an OTP for phone number verification and completes signup when all fields are filled.

User Interaction:
User fills in their details and selects their user type.
User taps "Send OTP" to receive a phone verification code.
After OTP verification, user completes signup and is redirected to the ConsumerHomeScreen (if a consumer) or an equivalent farmer home screen.

### Overall Navigation Flow
Signup/Login Screen ➔ ConsumerHomeScreen (for consumers).
ConsumerHomeScreen ➔ User selects a category ➔ ProductCategoryScreen (displays products in that category).
ProductCategoryScreen ➔ User selects a product ➔ FarmerListScreen (displays farmers offering that product).
FarmerListScreen ➔ User selects a farmer ➔ ProductDetailScreen (shows full product details from the selected farmer).
