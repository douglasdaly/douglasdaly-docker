# douglasdaly-docker.git

*Repository for building the docker containers to run [www.DouglasDaly.com](https://www.douglasdaly.com/ "My Website").*

## Configure

To configure the necessary variables for the build:

```bash
$ make configure
```

You'll also need to add the appropriate `production.env` file to the project for the web app (or ensure the required environment variables are provided somehow).


## Build

### Production:

To build the images needed:

```bash
$ make build
```

To push the images to a repo:

```bash
$ make push
```

*Note:* Currently setup with AWS ECR so settings in the main .env file reflect that.  The environment variables `AWS_REGION` and `DOCKER_REPOSITORY` are set there.

To do both the build and push in one step:

```bash
$ make
```

### Debugging/Staging

I've also setup some builds for testing the full setup on your local machine (sometimes there can be differences in what things look like behind NGINX/Gunicorn vs. the django runserver).

The following command will build and run the docker images in debug/staging mode:

```bash
$ make debug
```

To do just the build:

```bash
$ make debug_build
```

And just the run:

```bash
$ make debug_run
```

This runs the server in production mode but with django debug/local settings.


## License

This project is licensed under the MIT License.  See LICENSE file for details.

