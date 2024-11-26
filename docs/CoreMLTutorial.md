# CoreML Tutorial

Hey, thanks for joining! To give a quick introduction, I am going to assume you have a baseline knowledge of Swift, so this tutorial is not going to go over syntactical analysis by any means. This tutorial will be more focused on how to:

- Find data
- Train a model
- Implement it into a preexisting project

*Hint*: If you want to follow along using my app, feel free to fork this repository!

---

## Table of Contents

i. Finding Data\
ii. Converting the data into a CreateML readable structure\
iii. Getting Started with Create ML\
iv. Training Your Data\
v. Using Your Model\
vi. Congratulations!

---

i. **Finding Data**

In this section, you figure out specifically what kind of data you are looking for. You're in luck because I have a couple of websites that host TONS of free data for us to use!

### Option 1: [Hugging Face](https://huggingface.co)
This option has a bunch of pretrained models as well as datasets for people to train their own models.

### Option 2: [Kaggle](https://www.kaggle.com)
Like Hugging Face, Kaggle offers a large variety of pretrained models and free datasets.

Take some time here looking at everything and figuring out what works for you. For this tutorial, I am going to use the **celebrity-1000 dataset** created by [tonyassi on Hugging Face](https://huggingface.co/datasets/tonyassi/celebrity-1000).

This dataset is small enough to quickly train yet large enough to have some working functionality to it.

#### Downloading the Dataset:
1. Navigate to the dataset's [Files and Versions](https://huggingface.co/datasets/tonyassi/celebrity-1000) tab.
   ![Files and Versions Tab](https://github.com/user-attachments/assets/a7df554b-06f5-4196-b70d-5742a8c9be98)
2. Select **data**.
   ![Data](https://github.com/user-attachments/assets/c7012ff6-51d8-44d5-aab3-038d9387dbfe)
3. Click the download button and save it anywhere you'd like.
   ![Download Button](https://github.com/user-attachments/assets/02f8b755-b78c-48bf-819d-2400076a4bdb)

---

ii. **Converting the Data into a CreateML-Readable Structure**

This Python code will turn the data into a CreateML-readable structure:

```python
import pandas as pd

df = pd.read_parquet('train-00000-of-00001.parquet')
# Save it as a CSV file
df.to_csv('celebrity-1000.csv', index=False)
```

### Organizing Images:
Another script for organizing images into folders based on their labels:

```python
from datasets import load_dataset
import os
from format_labels import label_to_celebrity 
import pandas as pd
from PIL import Image

# Load the CSV file
csv_file_path = 'celebrity-1000.csv'  # Replace with your actual path
data = pd.read_csv(csv_file_path)

# Assuming the CSV contains 'image_path' and 'label' columns
base_dir = 'CelebImages'
os.makedirs(base_dir, exist_ok=True)

# Create folders for each celebrity
for label, name in label_to_celebrity.items():
    celebrity_folder = os.path.join(base_dir, name)
    os.makedirs(celebrity_folder, exist_ok=True)

# Iterate through the data and save images in respective folders
for index, row in data.iterrows():
    image_path = row['image_path']
    label = row['label']

    if label in label_to_celebrity:
        celebrity_name = label_to_celebrity[label]
        celebrity_folder = os.path.join(base_dir, celebrity_name)

        # Load the image and save it to the respective folder
        try:
            with Image.open(image_path) as img:
                filename = f"{celebrity_name}_{index}.jpg"
                filepath = os.path.join(celebrity_folder, filename)
                img.save(filepath)
        except Exception as e:
            print(f"Failed to save image for index {index}: {e}")

print("Images saved successfully.")
```

By the end of this, you should have a folder labeled **"CelebImages"** with subfolders containing the pictures.

---

iii. **Getting Started with Create ML**

(Coming soon!)

