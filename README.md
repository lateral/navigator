# Lateral Navigator

Let users generate a visual interface so they can interact with their data stored in the Lateral API.

<!-- ## Introduction -->
## Installation

Run `rake install` to install the assets.

## Running

Run `foreman start` to start the rails server and run gulp.

Visit the URL that BrowserSync outuputs in the terminal. This will most likely be `http://localhost:3000`.

## Development

### Folder structure

```bash
├── app     # The main application
│   ├── api          # Rails/Grape API
│   ├── assets       # Front-end assets
│   │   ├── images   # Images
│   │   ├── scripts  # The backbone/marionette application
│   │   └── styles   # SASS/Compass files
│   ├── helpers      # Rails helpers
│   ├── models       # Rails models
│   └── views        # HTML pages
├── bin     # Executables for rails, tests, etc
├── config  # Configuration files
├── db      # Databases amd migrations 
├── log     # Logs
├── public  # Front-end app is compiled to here
├── spec    # Tests
├── tmp     # Temporary files
└── vendor  # Third-party gems for Ruby
```
