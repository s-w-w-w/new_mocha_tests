#!/usr/bin/env bash 

# create new suite for testing javascript code with mocha and chai
# type -h for available options

# this script install mocha 3.5.0 and chai 4.3.7 add ^ before the version to get the latest version


#configuration
APPS_DIR=~/www/tests/mocha
APP_NAME=myLibrary
# detect help

# display help
Help(){
cat <<EOF
Usage: ${0##*/} [-h | -l libraryName | -d directory ]

    -h help
    -l libaryName - specify library name
    -d specify directory name

EOF
}

# parse script options
while getopts ":hl:d:" option; do
   case $option in
      h) # display Help
         Help "$0"
         exit;;
      l) # Enter application name
         APP_NAME=$OPTARG;;
      d) # Enter directory   
         APPS_DIR=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done
shift "$((OPTIND-1))"   # Discard the options and sentinel --


# set path 
APP_PATH="$APPS_DIR/$APP_NAME"

if [[ -d "$APP_PATH" ]]
  then {
    echo "There exists $APP_PATH already. Choose a different app name" 
    exit 2;
  }
fi 

mkdir "$APP_PATH"
cd "$APP_PATH"

# crate lib and write to app_name.js 
mkdir lib
cat <<END > "lib/$APP_NAME.js";
/*
sample JavaScript class
module.exports = class Color{
  values = [];
  constructor(r = 0,g = 0,b = 0){
    this.values = [r,g,b]
  }
  
  get(){
    return this.values;
  }
}
*/
END

mkdir test
read -r -d '' <<TND
// sample test of a class method
var assert = require('chai').assert
var $APP_NAME = require('../lib/$APP_NAME.js');

/* test of an instance method
describe('Color', function() {
  // runs once before the first test in this block
  before(function () {
  });
  // runs once after the last test in this block
  after(function () {
  });
  // runs before each test in this block
  beforeEach(function () {
  });
  // runs after each test in this block
  afterEach(function () {
  });

  describe('#get', function() {
    it('should return an array of 3 numbers', function() {
      const color = new Color(5,5,5)
      assert.equal(color.get().length,3);
    });
  });
});

// run this test using on the command line using command : mocha
*/

TND
echo "$REPLY" > test/tests.js

#write to package.json
cat <<BEND > package.json 
{
  "name": "$APP_NAME",
  "version": "1.0.0",
  "description": "",
  "main": "test.js",
  "directories": {
    "test": "test"
  },
  "scripts": {
    "test": "mocha"
  },
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "chai": "4.3.7",
    "mocha": "3.5.0"
  }
}
BEND

# install chai locally
npm install chai

# init new git directory
git init
echo 'node_modules/' >> .gitignore
echo 'package-lock.json' >> .gitignore
git add .
git commit -m 'Initial commit'
