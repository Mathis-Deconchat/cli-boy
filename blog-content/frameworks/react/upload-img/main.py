import os
from supabase import create_client, Client

url: str = "https://bdhoswolctxjsnlvwusu.supabase.co"
key: str = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJkaG9zd29sY3R4anNubHZ3dXN1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTMxMzQ0OTUsImV4cCI6MjAwODcxMDQ5NX0.jP3daOmEFL7miJK9QP-Ubdr-YO0MG8xVXBXsVGPhL54"
supabase: Client = create_client(url, key)

def fetch_images_from_directory(base_dir):
    """
    Parse the specified directory and returns a dictionary where
    keys are the folder names and values are lists of image paths.
    """
    result = {}
    
    # Iterate through all directories inside the base_dir
    for folder in os.listdir(base_dir):
        folder_path = os.path.join(base_dir, folder)
        
        # Check if it's a directory
        if os.path.isdir(folder_path):
            image_files = []
            
            # Iterate through files in the directory
            for filename in os.listdir(folder_path):
                # Check if the file has a .png extension
                if filename.endswith('.png'):
                    image_files.append(os.path.join(folder_path, filename))
            
            # Sort the list of image files for consistent order
            image_files.sort()

            # Add to the result dictionary
            result[folder] = image_files

    return result

if __name__ == "__main__":
    base_directory = "./assets2"  # current directory
    images_dict = fetch_images_from_directory(base_directory)
    print(images_dict)
    for folder, image_paths in images_dict.items():
        for image_path in image_paths:
            upload_name = "public" + "/" + folder + "/" + os.path.basename(image_path)
            print(upload_name)
            with open(image_path, 'rb') as f:
                response = supabase.storage.from_('todo').upload(upload_name, f)
            # Upload the image to Supabase Storage
            # response = supabase.storage.from_path(folder, image_path)



