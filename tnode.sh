#!/bin/bash
# Colors
blue="\033[0;34m"
yellow="\033[0;33m"
bold_yellow="\033[33;1m"
bold_blue="\033[34;1m"
bold_red="\033[31;1m"
green="\033[0;32m"
bold_green="\033[32;1m"
white="\033[0;37m"
# Symbols
check_mark="\xE2\x9C\x85"
info="\xE2\x84\xB9\xEF\xB8\x8F"

# Check if NodeJS is installed
command -v node >/dev/null 2>&1 || { echo >&2 "Error: Node.js is not installed."; exit 1; }


# Prompt user to enter a name for the NodeJS project
printf "$bold_blue Enter a name for your NodeJS project: $bold_yellow"
read name


# Check if a folder with the same name already exists
while [[ -z $name ]]; do
    printf "$bold_red You must enter a name for your project\n $bold_yellow "
    read name
done

# Check if a folder with the same name already exists
while [[ -d "$name" ]]; do
    printf "$bold_red Error: A folder with the name '$name' already exists.\n $bold_yellow "
    read name
done

# Create the project folder
mkdir $name

# Inform about project creation
printf "$green Creating $bold_yellow$name$white...\n"

# Change directory to the project folder
cd $name


# Initialize npm project with default settings
npm init -y > /dev/null 2>&1


# Install TypeScript as a development dependency
npm i -D typescript > /dev/null 2>&1


# Install ts-node as a development dependency
npm i -D ts-node > /dev/null 2>&1


# Create tsconfig.json file
npx tsconfig.json


# Install ESLint and TypeScript ESLint plugins as development dependencies
npm i -D eslint @typescript-eslint/eslint-plugin @typescript-eslint/parser > /dev/null 2>&1


# Create .eslintrc.json file with ESLint configuration
echo '{
	"root": true,
	"parser": "@typescript-eslint/parser",
	"plugins": ["@typescript-eslint"],
	"extends": [
		"eslint:recommended",
		"plugin:@typescript-eslint/eslint-recommended",
		"plugin:@typescript-eslint/recommended"
	],
	"rules": {
		"no-console": 0,
		"@typescript-eslint/no-inferrable-types": 0
	},
	"ignorePatterns": ["node_modules", "dist"]
}' > .eslintrc.json


# Create .eslintignore file to ignore specified directories
echo 'node_modules
dist' > .eslintignore


# Append scripts to package.json file
sed -i '' '/"scripts": {/a\
    "build": "npx tsc ./src/index.ts",\
    "start": "ts-node ./src/index.ts",\
    "js": "node ./src/index.js",\
' package.json



# Create .gitignore file for the project
echo "# Dependency directories
node_modules/

# Build output
dist/
build/

# Environment variables
.env

# Logs
logs/
*.log

# IDE specific files
.vscode/
.idea/" > .gitignore


mkdir src

echo "// Define a simple TypeScript class
class Greeting {
  private message: string;

  constructor(message: string) {
    this.message = message;
  }

  greet() {
    console.log(this.message);
  }
}

// Create an instance of the class and call the greet() method
const greeting = new Greeting('Hello, World!');
greeting.greet();" > src/index.ts


printf "\n$check_mark$bold_green Project $bold_yellow$name$bold_green created successfully!\n"

printf "\n$info $blue The following scripts will save your life\n\n"
printf "$bold_yellow npm run start $white> Execute your typescript (index.ts) directly\n"
printf "$bold_yellow npm run build $white> Convert your Typescript into JavaScript\n"
printf "$bold_yellow npm run js $white> Execute your JavaScript\n\n"


# Exit the script with success status
exit 0
