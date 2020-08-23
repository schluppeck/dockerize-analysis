## building the container

I used `neurodocker` to create a consistent `Dockerimage` - this is a superuseful tool that makes putting containers together much easier by allowing you to specify commonly used combinations of tools.

## generate the `Dockerfile`

The bash script ``generate.sh`` is a adapted version of the one used on the neurodocker tutorial page

```bash
sh generate.sh
cat Dockerfile
```

## build the container

```bash
# in the folder with the Dockerfile present
docker build -t MY_TAG .

# wait for > 20 layers to be built
# this will takes several minutes

# make sure it's there
docker image ls
```

Voilà!



