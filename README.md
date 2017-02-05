# RoonServer on Docker

This [Dockerfile](/Dockerfile) builds an image based on Alpine Linux to execute the Roon Server software.

We chose Alpine Linux in the hope of better controlling the software loaded into the running container.

## Roon requirements

The [Dockerfile](/Dockerfile) installs all dependencies specified in Roon's Knowledgebase page. Additionally, given that Alpine does not include support for _glibc_ in its base image, we ignored the official base image and took [frolvlad/alpine-glibc](https://github.com/frol/docker-alpine-glibc.git) instead, as it precisely includes just support for glibc on top of Alpine's base.

**_bash_** is also explicitly installed, as some of Roon's scripts require it.

## Roon Software installation and updating support.

The approach taken is to ignore Roon's easy installer. After all, we are setting up Roon's environment directly, and all that checking around is not contributing anything (on the contrary, as it may fail for some spurious reason).

Besides the above, during image build, we only download the Roon server package [RoonServer_linuxx64.tar.bz2] (http://download.roonlabs.com/builds/RoonServer_linuxx64.tar.bz2), but do not install it where it has to run. We do so to accomodate Roon's in-place update strategy as follows: in folder [/rooninstall]() we place the Roon Server package
[RoonServer_linuxx64.tar.bz2] (http://download.roonlabs.com/builds/RoonServer_linuxx64.tar.bz2), as well as script [roon_initial_installer.sh](/roon_initial_installer.sh), which is configured as the entrypoint of the image.

When we launch a container from this image, [roon_initial_installer.sh](/roon_initial_installer.sh) executes and checks if folder [/opt/RoonStuff/RoonServer]() exists. If it does, that means that the Roon server is already available, and does not need to be installed. If not, it installs the version of the Roon server added to the image (in [/rooninstall/RoonServer_linuxx64.tar.bz2] (http://download.roonlabs.com/builds/RoonServer_linuxx64.tar.bz2)) by expanding it cwithin [/opt/RoonStuff](), creating [/opt/RoonStuff/RoonServer]().

If Roon self-updates, it will modify the contents within [/opt/RoonStuff/RoonServer](), which will be annoying if, for some reason, the container running Roon is destroyed, as the Roon Server will need to be updated again.

To avoid it, the container must map a host directory into the [/opt/RoonStuff]() volume. This way, changes will be persisted and, when a new container is launched, the [roon_initial_installer.sh](/roon_initial_installer.sh) script will not reinstall Roon's server, using the one persisted instead.

## Launching a Roon container from this image

We have included a script, [startroon.sh](/startroon.sh), which is not copied into the image, but is there to give an example on how Roon could be launched.

Roon needs a persistent place where to store the database, and some way of accessing the music. We provide access to those places via volumes (declared as [/var/roon]() and [/music]() in the [Dockerfile](/Dockerfile), respectively, as was done in [mikedickey's](https://github.com/mikedickey/RoonServer.git) Dockerfile. 

This, coupled with our previous discussion on Roon updates, implies that we should associate three different host folders to the three volumes declared for the image, for which three environment variables are specified in [startroon.sh](/startroon.sh).

### Networking
The [startroon.sh](/startroon.sh) script uses **_host_** networking configuration. This means the container is using the same interfaces as the host OS. This should work on most Docker installations.

In my opinion, the container should use a _bridged_ configuration of some sort, in which it presents a separate virtual interface to the network, getting a separate IP address from that of the host, thus avoiding potential issues with port collisions.

This can be done in recent versions of Docker, or on hosts providing networking extensions for Docker with this kind of support (e.g., Docker on QNAP).

## Where has this been tested?

We are running it continuously on an Asustor NAS, with the Docker community-provided package installed (as Asustor does not support docker directly as of now). This package installs a version of Docker which is a bit outdated (1.10.x), and does not support a bridged mode with separate IP addresses.

We also tested it on Docker for Mac and QNAP TS-453A. We see no reason why it should not work on Synology or any Docker-supporting environment for that matter.

