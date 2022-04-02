# Docker setup for brand new rails projects

This project stores the very basic structure to start a ruby/rails project without any local installation

# Rails

## Preparing the environment
Make a copy form the file `.env.sample` to `.env` and fill in all the necessary env vars you'll need
Remember that changing the `APP_NAME` env is mandatory

Start a new Rails project:
```shell
docker-compose run --rm web scripts/setup
```


## PS
It's important to rebuild the main image after initializing your project to install the necessary gems inside the image

```shell
docker-compose build web
```

## Last but not least
After rebuilding the image your service should be ready to go

```shell
docker-compose up
```