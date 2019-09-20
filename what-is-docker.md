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

Now that we have some basic definitions defined and terms outlined, let's get into the basic of Docker. Docker can be installed on just about any OS, and I think Windows might even be supported now. To install Docker, you can run the [script](https://github.com/jbmcfarlin31/git-and-docker-tutorial/blob/master/install_docker.sh) that I have provided. It will go out and get the official docker repository key, add the repo to the local boxes repo list (`/etc/apt/sources.list/`) and then install docker and configure the docker daemon to be accessed from other users (`usermod -aG docker ${USER}`). I should note that this will install Docker on `Ubuntu 16.04`, but can be modified based on the flavor of Linux you are running.

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

If you look at the above output, you notice those layers were not pulled before and thus required pulling, however, if we reuse the same image again, you will notice since they are cached - a pull does not occur and build time is increased:
```bash
$> docker pull docker/whalesay
latest: Pulling from docker/whalesay
e190868d63f8: Already exists 
909cd34c6fd7: Already exists 
0b9bfabab7c1: Already exists 
a3ed95caeb02: Already exists 
00bf65475aba: Already exists 
c57b6bcc83e3: Already exists 
8978f6879e2f: Already exists 
8eed3712d2cf: Already exists 
Digest: sha256:178598e51a26abbc958b8a2e48825c90bc22e641de3d31e18aaf55f3258ba93b
Status: Image is up to date for docker/whalesay:latest
```

## Viewing pulled and built images

The command `docker images` can be used to show what images are currently pulled down onto the local repository.
This is basically doing an `ls` command within the docker daemon.

To list what images have been pulled down locally and/or built, you can do:
```bash
$> docker images
REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
docker/whalesay              latest              6b362a9f73eb        4 years ago         247MB
```

If you manually built your image using `docker built -t TAG .`, the `TAG` name will be listed here.

## Running the built container

Once you have built your image or pulled an image down, you can run that image as a container so that the application can be deployed and available.

<b>NOTE: there are a variety of docker images presented on [Docker Hub](https://hub.docker.com/) that can be used for your container, or you can  build your own as mentioned above.</b>

We can run a container by performing the following:
```bash
$> docker run --name whalesay -dit docker/whalesay
Unable to find image 'docker/whalesay:latest' locally
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
6fcf2f8cccbae6f875d9536882066fbd4b6af94b208393f6a64546eb7edbe263
```

If the container image has already been built, you will not get the `Pull ...` statements, you will just get a UUID for the container:
```bash
$> docker run --name whalesay -dit docker/whalesay
f58554caab0356ea74285f354c508c1d515b8ff080b9f0b595dfa23bbb861674
```

Notice the flags in the `docker run` command? Let's break down what those are:
```bash
-d, --detach                         Run container in background and print container ID
-i, --interactive                    Keep STDIN open even if not attached
-t, --tty                            Allocate a pseudo-TTY
```
You can easily see these also using `docker run --help`.

To check if your container is running, refer to the next step.

## View running containers

When a container has been executed - sometimes they stay running based off the flags passed into the `docker run` statement, and sometimes they exit because they completed their job. Remember, a container is meant to do one thing and are considered ephemeral. They do not need to be long-lived (and in fact, are encouraged not to be!). One way to see if your container is running is to utilize docker's `ps` command, which is similar to linux `ps` command for processes. This instructs the docker daemon to show a list of running containers.

Here is an example:
```bash
$> docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
43360d25ecb2        docker/whalesay     "/bin/bash"         39 seconds ago      Up 38 seconds                           whalesay
```

Now, there are a handful of flags that can be passed to the `ps` command, especially if the container ran and exited. You might see this with a container that spins up, does some math computations, and exits (obviously a super basic use case... but you get the point). In this case, running a `docker ps` will not show it as a `running` container because it has exited. This is where the `-a` flag comes into play: `docker ps -a`.

This command will show you ALL containers both running and stopped (exited), and then from there you can troubleshoot or view the logs of your container to see why it stopped if it was not supposed to.

Another useful flag is the `-n INT` flag, for example `docker ps -n 1`. This tells docker to only pull back the first most recent container that was last deployed (whether running or not). Now the `INT` can be changed to anything of your choice as well.

## Getting into a container

When a container comes up, sometimes it is useful to either get data from it, view other logs or processes within it, or just to do basic troubleshooting. Since a container is a shared subset of linux processes and namespaces, you can essentially `ssh` into the container.

To get inside a running container you can do the following, notice the change from `$` to `#`:
```bash
$> docker exec -it whalesay sh
#
```

This means you are now inside the container and can execute linux commands that have been loaded into the container via your Dockerfile. <b>Remember, containers are meant to be lightweight, and only include the packages/libraries needed for the application to function!</b>

You should also note the command at the end `sh`. This a requirement for the `exec` command because this tells the container what you are going to do - and it has to be a command that is installed within the container, otherwise you will get an error.

I know what you are thinking... _"What does the `-it` mean?"_, so let's cover that. Those are docker flags for the exec command - and in this case, the `-i` means interactive and the `-t` means tty (implements a pseudo-TTY). This is what allows you to _ssh_ into the container interactively. There are a handful of other flags that can be passed, just hit up the docker documentation for full explanations.

## Debugging a container

Sometimes it is necessary to figure out why a container is not performing the way you expected it to. This means looking at processes or components within the container using `exec`, and more often then that it also means looking at application and/or system logs. Docker has a convenient way for you to view this using the `logs` command in conjunction with docker.

To view the `stdout` or `stderr` of the container, you can just: `docker logs <container_name>` (e.g. `docker logs whalesay`).

This will output to your terminal the output of that container. Now, not all logs are setup to write to stdout, so some logs you will have to exec into the container to view. But if you know where the location of the log is, you can easily copy that using the `cp` command: `docker cp <container>:/path/to/file .` or vice versa (`docker cp myfile <container>:/path/to/file`.

## Removing resources (images or containers)

Performing clean up duties in docker is really useful since disk space can be consumed rather quickly. The easiest way to clear data up fast is to remove unwanted images, and remove stopped or exited containers. Luckily docker has some neat commands to help with this.

To remove a specific image, you can do: `docker rmi <image_tag>` (e.g. `docker rmi whalesay`)

If the image is not in use (e.g. in a running container), you can remove it. Otherwise, you will need to stop the container (`docker stop whalesay`) or add the `force` flag, such as `docker rmi -f whalesay`.

To remove a specific container, you can do: `docker rmi <container_name>` (e.g. `docker rm whalesay`)
If the container is running, this will error - but can be removed by adding a `force` flag as well: `docker rm -f whalesay`.

## Advanced Docker Topics

Some advanced topics around docker that we aren't covering (but can if the request is there) are:
- Inspecting a docker resource: `docker inspect <image_tag>/<container_name>`
  Useful for looking at the JSON specifics of a container or image (or other resource). It basically does a data dump of everything you need to know about that resource.
  
- Using docker filters for resources: `docker images -f dangling=true`
  Useful for filtering out wanted resources and reducing noise, but can also help with scripting functions such removing all images that are considered orphaned (e.g. `docker rmi $(docker images -f dangling=true -q)`).
  
- Using Docker volumes to create mount points from the docker host to inside a container.
  EXAMPLE: `docker run -v HOST:CONTAINER` ... `docker run -v /etc/certs/ssl:/etc/certs/ssl`.
  
- Using environment variables and build args for deployments.
  ENV vars can be set in a Dockerfile or on the command line:
  - Dockerfile
    ```Dockerfile
    FROM ubuntu:latest

    ENV http_proxy=127.0.0.1
    ```
  - Command line: `docker run -e http_proxy=127.0.0.1`
  
- Docker networking, such as how to configure overlay networks, port forwardings and so on.
  - Port forward from container to host: `docker run -p 8080:80` (forwards port 80 in the container to 8080 on the localhost (localhost:8080)
