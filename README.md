# ChainofRestraunts
This repository contains the contents of a Project that contains a database that is supposed to hold a 
chain of restraunts. It will have tables that include the payments for orders, frequent customers as well as the locations for restraunts. 

Criteria from prompt
A chain of restaurants: food kind (texan, chinese, indian, french, italian, etc), diverse food/beverage items. Consider payment info, package meals, tax, tips, restaurant location. Customers with/without loyalty (membership) card. Ability to pay with card or cash. Basic bank account information.


** For those who are grading our assignment **

Thank you for taking the time to look and assess our assignment, if you have any issues please contact us on discord!

- First things first, we need to understand the prerequisite software that we are using to set up the assignment. We are using Node as a framework for our website. 
** NOTE if you do not have node downloaded here is the link to download it: https://nodejs.org/ **

- Using commands that come downloaded with node, double check to see if you have the dependencies downloaded within our folder/directory (we should already have them in the folder):

      npm install 

- Now look at our .env file. It should have a template like this:
    DATABASE_URL=postgresql://username:password@localhost:5432/Restaurant
    PORT=3000
  Adjust the **Username** to your own username to your postresql on your personal machine. As well as the **Password** for your postresql.
  Please note the port that is used.

  - We have inluded a .sql file named schema.sql (this does not include our full database but it creates the neccary tables needed for our transactions aswell as populating the database)
    What you will need to do is create a server called Restaurant on postresql and then right click to select query tool to then copy from the sql file to then paste into the query to
    then run it.
    
  🎈Congratulations you have created our database🎈

  Now we are hitting the home stretch type node index.js  into the terminal or command panel and you will activate our website on: 
    🌟 http://localhost:3000 🌟

Again we are available if there are any issues regarding setting up the website if not contacted originally from one of our teammates contact, ww2geek101 for any questions thank you!

