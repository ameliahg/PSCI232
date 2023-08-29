# PSCI232 #
This repository contains all the data and code we'll be working with in PSCI 232.

## Code ##
All the code here is available for you to use. To download some code ("code" is anything with a .R at the end), you can do one of two things:

**Thing one**
1. From the main page (https://github.com/ameliahg/PSCI232), click the .R file you want to put on your computer. This will take you to the file's page.
2. In the second gray bar, you should see some buttons: Raw, Blame, a screen, two squares, a pencil, and a garbage can.
3. Click the two squares to copy the whole contents of the code to the clipboard.
4. In RStudio, open a new script file (remember, that's the little green plus sign at the top left).
5. Paste the code you just copied into the file.
6. Save the file to your PSCI 232 folder.

The advantage of Thing One is that you won't be downloading unnecessary data.

**Thing two**
1. From the main page (https://github.com/ameliahg/PSCI232), click the green Code button and choose "Download ZIP." This will download the ENTIRE repository -- all the data and all the code -- as a giant zip file.
2. Click the file to "unzip" it. The code you want, and all the other stuff from the PSCI232 repository, will be in a new folder called PSCI232-main.
3. Open the file you want to play with.

The advantage of Thing Two is that it automatically creates the PSCI 232 folder I'd like you to have! It has the disadvantage that, each time you download the repository, you'll be getting the whole folder, potentially creating confusing multiple copies. My suggestion that you either (1) always save the zip file with the same name or (2) make sure to discard old downloads as soon as the new one is in place.

## Data ##
You are welcome to download data directly to your computer, but as we've seen in class, this can create complexity (and take up a lot of extra space on your computer). My preference is that you read data directly from a Github URL rather than downloading and reading from a file. If you want to look at the raw data, feel free to download and open in Excel (or copy-paste into Excel via the Raw button), but for the purposes of our work, I'll always ask you to read from Github. Here is how you read from Github:

1. From the main PSCI 232 page, click the folder you want and, within the folder, the file you want to use.
2. Find the button (at the top, toward the right) that says "Raw." Click it! You should see the data --- not in tabular format but in plain text.
3. Copy the URL of this page.
4. Paste the URL into your code, as in "< cy <- read_csv("https://raw.githubusercontent.com/ameliahg/PSCI232/main/country-data/country_stats_byyear.csv") >.
5. As long as you have a wifi connection, you should be good to go.
