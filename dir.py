import os

def create_structure(base_path):
    # Define the hierarchical file structure as a nested dictionary.
    structure = {
        "lib": {
            "main.dart": None,  # Files are represented by None (or an empty string) since no content is needed.
            "screens": {
                "welcome_page.dart": None,
                "login_page.dart": None,
                "home_page.dart": None,
                "mood": {
                    "happy_mood.dart": None,
                    "stressed_mood.dart": None,
                    "sad_mood.dart": None,
                    "angry_mood.dart": None,
                    "calm_mood.dart": None
                }
            },
            "services": {
                "api_service.dart": None
            }
        }
    }

    def create_items(parent, items):
        for name, value in items.items():
            # Construct the full path for the item.
            path = os.path.join(parent, name)
            # If the value is a dictionary, create a directory and recurse.
            if isinstance(value, dict):
                os.makedirs(path, exist_ok=True)
                create_items(path, value)
            else:
                # Otherwise, create an empty file.
                # Ensure the parent directory exists.
                os.makedirs(parent, exist_ok=True)
                with open(path, 'w') as f:
                    pass  # Creates an empty file

    create_items(base_path, structure)

if __name__ == "__main__":
    # Optionally, set the base path where you want to create the structure (default is current working directory).
    base_directory = "."
    create_structure(base_directory)
    print("Directory structure created successfully!")
