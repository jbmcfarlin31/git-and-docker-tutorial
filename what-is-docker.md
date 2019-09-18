# What is Docker?

Traditional software development meant having to find a place to run your application, finding a system administrator to manage your virtual machine that will be running the application, and all of the logistics that go alongside with that. However, modern software development has switched to a new methodology of `containers` and `microservices`, all easily achieve and faciliate through a tool called `Docker`. 

Docker is a tool that was designed with the developers in mind, they wanted something that would easily allow a developer to create, deploy, and run their application by means of containers. Before we dive to much far, lets understand some basic terminalogy and definitions.

### Definitions
- <b>_Container_</b> - an application with only the requirements it needs to run, assembled into a small (or large) package that can be deployed anywhere. Now all of this is mumbo-jumbo, right? Let's break it down:

    Let us start with the underlying OS of a container. A container shares the underlying OS that is running Docker, it is broken up by what they call as namespaces. These namespaces allow the different processes that normally run on a VM to be isolated as their own mini VM on the VM, if that makes sense.

    Take a look at this image, courtesy of Docker documentation:
    ![alt text][logo]

    [logo]: https://docs.docker.com/images/Container%402x.png "Container Layout"

    The underlying infrastructure could be bare metal machines that run inside a server rack. The host OS might be ESXi (for VMWare) or a different hypervisor such as hyperV from Microsoft. And then a virtual machine gets deployed onto that hypervisor running a flavor of Linux, and Docker sits on top of that as an installed binary package. 

    The container takes the host OS and segments out shared name processes to be run inside the container itself, so that you can have one VM with Docker running many containers.

    The container is derived from an image (or OS), and the binaries, libraries, and packages needed to run the application will be loaded onto it - nothing else. Once everything is installed and loaded, the container is built as an image to be referenced elsewhere. More on this to come!

- <b>_Microservices_</b> is a new way of writing and structuring applications. It focuses on structuring the application as a collection of services so that it may achieve:
    - Maintainability and testability
    - Loosely coupled designs
    - Independently deployable
    - Owned by it's own team, no one else

    Microservices allow the developer to decouple a monolithic legacy application into smaller, more manageable segments so that they may be independent of one another and isolated if failures occur. As much as I can explain, sometimes it is better with an example:
    - I have an old Apache or Nginx webserver that is running a NodeJS or Python application on it. My team is afraid to upgrade nginx or make system patches in fear it might break the applications or update the specific version of Python libraries we need to run our app. Not to mention the cost and resources it takes to run it.

    - Using Docker and containers, we can break apart our application so that all the related components are interdependent of each other, and can each be deployed as a container. Apache/Nginx can run in its own container, and the Python app can run in its own container, allowing us to simply deploy both containers, leveraging API's and docker networking to access the app over external sources.

    - This means now that Apache/Nginx is it's own configuration, and the Python app is it's own app, we can easily and reliable upgrade packages to one or the other without worring about breaking things. And since we can tag different image builds with different versions, rollback is much easier to do.

- <b>_docker pull_</b> is very similar to `git pull` in the sense of Docker actually has it's own local repository and public repo that you can pull images from. Instead of files (like in git), image builds are stored.

- <b>_docker push_</b> is very similar to the `git push` command in the sense that Docker will take the image you built and push it to the local repository and/or the public/private repo of your choice.

- <b>_docker commit</b> is very similar to the `git commit` command in the sense that Docker will take the image you built and push it to the public repo for Docker called `Docker Hub`.

- <b>_Dockerfile_</b> is the main file that will be used and referenced when building out your docker image, here is where you specify the configurations, users, packages, libraries, etc. that the application will need to function in the containe. Think of it as the instruction set that will be used for building the plan to run your container.

Now that we have some basic definitions defined and terms outlined, let's get into the basic of Docker. Docker can be installed on just about any OS, and I think Windows might even be supported now. To install Docker, you can run the [script](https://github.com/jbmcfarlin31/raw/master/install_docker.sh) that I have provided. It will go out and get the official docker repository key, add the repo to the local boxes repo list (`/etc/apt/sources.list/`) and then install docker and configure the docker daemon to be accessed from other users (`usermod -aG docker ${USER}`). I should note that this will install Docker on `Ubuntu 16.04`, but can be modified based on the flavor of Linux you are running.

Once docker has been installed successfully, you can perform the various docker commands that we will be covering:
- `docker build -t <image-tag> .`
- `docker run [OPTIONS] <image-tag>`
- `docker images`
- `docker ps`
- `docker exec [OPTIONS]`
- Various removal commands (`docker rm`, `docker rmi`)

To verify that the docker daemon is running, run the following:
`service docker status`

If the docker service is running, verify the logged in user can access the daemon by running `docker ps`, this will pull back an emty column chart if successful showing that you have no containers running.

If all of those checks work, you are ready to start creating your first docker application to run inside of a container.

## Building an Image to Run as a Container

The building blocks of a container stems from an image. An image is built based on the instruction set of a `Dockerfile`. A Dockerfile is what houses all of the information for how the image and application should function. Let's look at an example Dockerfile and break it down.

```Dockerfile
FROM docker/whalesay

CMD ["/bin/bash"]
```

This example is super basic, so let's break it down further:
- _FROM_ indicates where the image is coming from, basically the repo that the Docker daemon will be able to issue a `docker pull` from.
- _CMD_ indicates the command that will be executed when the container spins up. This can also be what is called an `Entrypoint`. 

Let's take a less simpler Dockerfile, such as:
```Dockerfile
FROM ubuntu:latest

COPY app.py /data/app/

RUN apt-get update && \
    apt-get install -y jq

CMD ["/bin/bash"]
```

This example has a little more going on with it, let's go deeper:
- We already know what the _FROM_ and _CMD_ commands do. So let's skip those.
- _COPY_ is similar to the _ADD_ command - they basically do the same thing, which is `copy` from `src` to `dest`. It is important here to note that the `src` must be a file that exists in the same directory as the Dockerfile, otherwise the copy will not work.
- _RUN_ is an instruction for Docker that tells it to execute a command inside the container. In this case, we are performing an `apt-get update` and then we are installing the JSON parser utility called `jq`. An important thing to note here is that anything you plan to install inside the container, you <b>MUST</b> pass the `no user input` flag (in this case `-y`) for force install - otherwise the `docker build` will fail.

You can do many other commands, and options are almost endless. But these are the basic we will need for the sake of this tutorial.

So now that we have a `Dockerfile` configured, your directory should look something like:
```bash
$ > ls
Dockerfile app.py
```
You are going to want to build the image using the following:
```bash
$ > docker build -t myfirstdockerimage .
```
This command tells the docker daemon that we are going to build an image, we pass the `-t` flag indicating we are going to name this image `myfirstdockerimage`, and then finally we indicate that the `Dockerfile` exists in the current directory that we are executing the `docker build` command. You can specify a Dockerfile location for that if you were building elsewhere.

You should now see the following context occur:
```bash
latest: Pulling from docker/whalesay
e190868d63f8: Pull complete 
909cd34c6fd7: Pull complete 
0b9bfabab7c1: Pull complete 
a3ed95caeb02: Pull complete 
00bf65475aba: Pull complete 
c57b6bcc83e3: Pull complete 
8978f6879e2f: Pull complete 
8eed3712d2cf: Pull complete 
Digest: sha256:178598e51a26abbc958b8a2e48825c90bc22e641de3d31e18aaf55f3258ba93b
Status: Downloaded newer image for docker/whalesay:latest
43360d25ecb20e54f32185af7f9c00ffdc1d7569d7c8ac8db419e3c9979da6db
```

Docker leverages the use of a cache so that when builds have pulled their images, and executed the layers of the Dockerfile (indicated by `Pull complete`), they can be reused elsewhere in subsequent builds for faster improvement and performance. There are tons of documentation online for optimizing your docker builds and the idea behind this is usually you pair your docker builds and deploys with a CI/CD pipeline (such as GitLab or GitHub), so that the automated process happens for you versus manually having to run theses commands. When the cache grabs the layers, if you use the same commands in a different Dockerfile, they will be reused from the cache, speeding up build time.
