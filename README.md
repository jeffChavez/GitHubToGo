GitHubToGo
==========
Week 3 Assignment

![Imgur](http://i.imgur.com/gG3LKc2.png)
![Imgur](http://i.imgur.com/qFNs4Ih.png)

![Imgur](http://i.imgur.com/qbW36Ms.gif)

###Assignment
Monday
- Implement a split view controller in your app to control your interface
- Create a network controller and implement a method that fetches repositories based on a search term. Instead of pointing the request at the Actual Github API server, use the node script provided in the class repository and point the request at your own machine. Since our apps aren't authenticated with Github yet we will hit the rate limit after 5 unauthenticated calls from our IP. The node script is called server.js. Just run it with your node command in terminal.
- Create a RepositoryViewController and parse through the JSON returned fromm the server into model objects and display the results in a table view.
- Devise a way to show the master view controller when the app is first launched on iPhone, not the detail view controller.

Tuesday
- Implement an OAuth workflow in your app that successfully lets the user authenticate with your app.
- Recreate a NSURLSession with a NSURLSessionConfiguration with the Authorization Header Field matched up with our oath token.
- Implement a UISearchBar on your repo search view controller and modify your repo search fetch method on your network controller to use the search bar’s text. Be sure to only be making authenticated network calls using your oath token!
- Display the repo’s they searched for a in the table view
- Implement user defaults to store the authorization token, so it only does the OAuth process once.

Wednesday
= Create a UserSearchViewController that searches for users, similar to how we are already searching for repositories. Instead of a table view, use a collection view to display the users avatar image and their name.
- Upon clicking on a cell, implement a custom transition, and transition the image clicked on to a UserDetailViewController page that has their picture, name, and whatever other info you want pulled from their API.

Thursday
- Implement Regex in your app. Use it to validate the characters the user types into the search bar. Extend String with this functionality.
- Implement WKWebView in your app. When a user clicks on a repo, show their repo's web page with WKWebView.

Friendship Friday
Pair programming rules:

- You must be working in a pair of 2 at all times. The best pairs have similar experience levels. Choose a new partner each week!
- One person will be typing (driving), but the other person needs to actively contribute. Each line of code you guys write should be discussed and decided upon. Keep an open mind, and if you guys disagree on something, try one way first and see if it works, if it doesn't try the other way.
- Don't physically harm your partner.
- Switch roles every half hour.
- Remember to high-five when you guys do something awesome. See http://en.wikipedia.org/wiki/High_five (Links to an external site.) for more info on this social ritual.
- The friendship friday challenges can be submitted jointly, if the work you did is on a different person's project, please note that in your homework submission. If the feature(s) you guys built is so awesome you just have to have it in your own project, copy it over.

Challenges:
- Implement the 'My Profile' view controller in your app. This should display info about the currently logged in user (their bio, if they are hirable, their count of public and private repos, etc).
- Implement a way for the logged in user to create a repo from the app. Good luck and god bless.
- Implement a way for the user to update their bio.
 
test commit
