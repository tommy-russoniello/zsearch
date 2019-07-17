# zsearch

### Dependencies
- Ruby 2.5.3

### Setup
1. Clone the repository to your machine and switch to its directory
2. Run `bundle install` to install and set up the necessary gems
3. Run `rails db:schema:load` to set up the database tables
4. Run `rails db:seed` to seed the database

Note: Run `rails db:reset` to reset the database

### Starting
1. Go to the directory for zsearch on your machine
2. Run `rails server` to boot up the server on port 3000
3. Open up a browser (preferably Google Chrome) and go to `http://localhost:3000`

### Searching
- When running zsearch in your browser, use the bar at the top of the screen to navigate through the app
- You can access searching and listing for an entity by hovering over its corresponding icon
  - Listing is for showing all instances of an entity
  - Searching is for finding instances of entities that match a search term on particular fields
- You can search on an entity by entering a search term into the search bar and selecting the fields of the entity that you want to search on for that term
  - Note: When selecting multiple fields, the results are ANDed together, not ORed
- Search terms don't have to match the results exactly except for enumerable, boolean, and set attributes
- When in a listing or search results page, you can click on any of the results to be brought to a different page that will show all of the fields for that result

### Testing
- Run `rubocop` to lint the project based on settings in `.rubocop.yml`
- Run `rails test` to run the test suite

### Notes
Although this is a basic searching application, I tried to design it in such a way that it could be built upon. In particular, I wanted it to be expandable in ways that would require more use of model logic, such as adding the ability to create new records. Some future enhancements that could be made besides this could be the highlighting of fields that were matched on in a search, or the ability to combine conditions with ORs instead of only with ANDs.
