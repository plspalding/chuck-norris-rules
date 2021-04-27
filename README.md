# Chuck Norris Rules

The project has been developed with a unidirectional flow pattern based off https://github.com/pointfreeco/swift-composable-architecture. All app actions are in one enum. This is ok for a small application. However if the app was to continue growing, then a need would arise to separate the actions by grouping certain actions together. This could be achieved with modifications to current code. However it would be more advisable to use the library linked earlier. This decision was taken as importing a third party library for a small app with limited functionality seemed like overkill, yet still allowing us to switch over quickly should it be necessary.

### How to use the app

When the app starts you will be presented with 2 options. 

Option 1: Allows you to fetch a list of jokes that will be displayed in a list. Clicking on a cell will add the joke to your favourites. There is also a refresh button that fetches new jokes and an options button which currently contains a screen which describes the options that are coming soon.

Option 2: Allows you to see the jokes you have favourited. These jokes are not yet persisted across app starts. However this would be a nice feature to add in the future.

### Tests

Tests are currently covering a range of actions that can be triggered. You can run the tests using command+u as per normal. The UI tests have been disabled for the scheme to allow for fast running of the tests. The approach that will be taken for UI, is to use screenshot testing (though this hasn't been implemented yet).
