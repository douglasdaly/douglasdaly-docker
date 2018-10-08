# douglasdaly-docker.git

*Repository for building the docker containers to run [www.DouglasDaly.com](https://www.douglasdaly.com/ "My Website").*

## Build

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


## License

This project is licensed under the MIT License.  See LICENSE file for details.

