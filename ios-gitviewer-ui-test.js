"use strict";

var local = {
  host: 'localhost',
  port: 4723
};

var wd = require("wd"),
    _ = require('underscore'),
    Q = require('q');
var assert = require('assert');

var configureLog = function (driver) {
  // See whats going on
  driver.on('status', function (info) {
    console.log(info.cyan);
  });
  driver.on('command', function (meth, path, data) {
    console.log(' > ' + meth.yellow, path.grey, data || '');
  });
  driver.on('http', function (meth, path, data) {
    console.log(' > ' + meth.magenta, path, (data || '').grey);
  });
};

describe("Git Viewer", function () {
  this.timeout(300000);
  var driver;
  var allPassed = true;

  //Setup
  before(function () {
    driver = wd.promiseChainRemote(local);

    // Please change the app path to match the dir for GitViewer.app
    var appPath = "/Users/Joseph/Documents/Projects/iOS/IDT/appium/sample-code/apps/GitViewer/build/GitViewer.app";

    var desired = {
      browserName: '',
      'appium-version': '1.3',
      platformName: 'iOS',
      platformVersion: '8.2',
      deviceName: 'iPhone Simulator',
      app: appPath
    };
    return driver.init(desired);
  });

  //Teardown
  after(function (){
    return driver
      .quit()
      .finally(function () {
      });
  });

  afterEach(function () {
    // Legacy Testing
    allPassed = allPassed && this.currentTest.state === 'passed';
  });

  // IDT (Image Differece Testing) Test Function
  var IDT = function(driver, path, originalName, testName, threshold, callback)
  {
    var originalImage = path + originalName;
    var testImage = path + testName;
    
    // Take Screenshot of UI
    driver.takeScreenshot("", function(error, img){
      // Save Generated Screenshot to Disk 
      require("fs").writeFile(testImage, img, 'base64', function(err){
        var exec = require('child_process').exec;
        function execute(command, callback){
            exec(command, { cwd: path }, function(error, stdout, stderr){ callback(stdout); });
        };

        // Call Command Line Tool (IDT) and pass it the Original Image + Generated Image + Threshold for comparison
        execute("./IDT " + originalName + " " + testName + " " + threshold  , function(output){
          // IDT will return 'pass' or 'fail'. 
          callback(output == "pass");
        });
      });
    });
  };

  // First Test case
  it("should fail the test after 3 seconds", function (done) {
    setTimeout(function(){
      
      // Set Path To Image File Directory
      var path = "/Users/Joseph/Documents/Projects/iOS/IDT/appium/sample-code/apps/GitViewer/build/";
      
      // Set Original Comparison Image
      var originalName = "Original1.png";
      
      // Set Generated Image Name 
      var testName = "Test1.png";
      
      // Set Threshold For Comparison
      var threshold = 43;
      
      IDT(driver, path, originalName, testName, threshold, function(isAcceptable){
        assert(isAcceptable);
        done();
      });
    }, 3000);
  });

  // Second Test Case
  // Same as the First Testcase, except the threshold is set higher (50)
  it("should fail the test after 3 seconds", function (done) {
    setTimeout(function(){
      
      // Set Path To Image File Directory
      var path = "/Users/Joseph/Documents/Projects/iOS/IDT/appium/sample-code/apps/GitViewer/build/";
      
      // Set Original Comparison Image
      var originalName = "Original1.png";
      
      // Set Generated Image Name 
      var testName = "Test1.png";
      
      // Set Threshold For Comparison
      var threshold = 50;
      
      IDT(driver, path, originalName, testName, threshold, function(isAcceptable){
        assert(isAcceptable);
        done();
      });
    }, 3000);
  });

});
