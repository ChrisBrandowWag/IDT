# IDT
A Prototype Image Dif Testing Framework For Appium

Goal:
- Add an extension / command to Appium that will trigger a UI Screenshot.
- Diff the screenshot + threshold to a known good screenshot.

For this to work you must first install appium:
http://appium.io/

Install Appium:
> brew install node      # get node.js
> npm install -g appium  # get appium
> npm install wd         # get appium client
> npm install mocha      # install mocha
> appium               	 # start appium

Install Xcode:
- Go to the mac appstore and install Xcode 6.2

Running IDT Framework Test:

- Edit "ios-gitviewer-ui-test.js" and change the paths in the src code to match your appropriate directory for where you have cloned your project.
- In /Build/GitViewer.APP you will find the pre built sample app that will be tested.
- In root of the git repo, you will find IDT command line tool. The source for this tool which I have written can be found under /IDT_SRC directory. It is an Objective C Command Line Application.
- Make sure that IDT has permission "chmod" for execution. 

Once Ready, run "mocha your-appium-test.js" to begin executing the test.
All of the output can be found in the /Build directory.

--
IDT Command Line Application
The IDT Command line App is the unit that does the actual image comparison between the base screenshot and the generated UI screenshot. It can be used as a standalone tool.

Usage:
IDT original_image.png test_image.png <threshold_value> <verbose(optional)>

Output:
Console.out = PASS | FAIL
Diff.png will be written to disk (current directory) - This File will Have all the diferenece in the image marked in RED.