# dockerize-analysis

setting up for reproducible code for running data analysis workflows at UNUK

```bash
# to run (this 
docker run -it --rm -p8888:8888 docker.pkg.github.com/schluppeck/dockerize-analysis/nipype_test:1.0
```

The first time you run this, docker needs to download the image (~4gb), so have some patience... but after this you should be able to start up the container very quickly.

Alternatively, you can docker pull the image first as per instructions under the packages tab and the `docker run` your downloaded version.

## Running from terminal

![starting container](docker-run.png)

![connecting to notebook server](notebook-running.png)

