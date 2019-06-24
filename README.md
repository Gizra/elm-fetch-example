`elm reactor` and navigate to http://localhost:8000/src/elm/Main.elm

## Deploy to gh-pages

1. One time: Set GitHub Pages to listen to the `/docs` folder on `master` branch.

Execute `elm make ./src/elm/Main.elm --output=./docs/index.html --debug`, and commit.