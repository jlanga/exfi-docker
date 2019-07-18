# exfi-docker
Build a Docker container with all the tools to execute exfi

# How to install

```sh
docker build --rm --tag exfi:1.5.6 github.com/jlanga/exfi-docker
```

# How to run each command

```sh
# Build
docker run --rm exfi:1.5.6 build_baited_bloom_filter --help

# Create Splice Graph
docker run --rm exfi:1.5.6 build_splice_graph --help

# Stay inside the container
docker run -it --rm exfi:1.5.6
```

Don't forget to mount your folder inside!

```sh
docker run --rm exfi:1.5.6 -v $PWD:$PWD build_splice_graph --help
```

# Contact info
Submit issues here or in the jlanga/exfi repository.

# References
[jlanga/exfi](https://github.com/jlanga/exfi)
