A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

#### Note: 
## Install
- **npm install -g nodemon**

## use nodemon
- **npm init -y**
- Add script into package.json: 
```
"scripts": {
  "dev": "nodemon --exec \"dart run lib/server.dart\" --ext dart"
}
```

## Run server:
- **nodemon --exec "dart run lib/server.dart" --ext dart**
- **npm run dev**
- **yarn dev**

## Test server: 
- **curl http://localhost:8080/**

## Build model:
- **dart run build_runner build** || **make build**