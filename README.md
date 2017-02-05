# RoonServer on Docker

The Dockerfile builds an image based on Alpine Linux to execute the Roon Server software.

Instead of holding the Roon Server deployed software within the built image, we just place the tar of
the software files within it.

On first execution, we untar the software onto /opt/RoonStuff, unless we already find the RoonServer folder in it.

We take the approach of mapping a host voume to /opt/RoonStuff, to support Roon's in-place update strategy, 
persisting the effects of such updates accross updates.

I have included a script to launch a docker container based on this image (startroon.sh)
This script has three environment variables to be configured for your particular situation.
Each one of them points to a different directory/volume to be mounted in the container, and their purpose is self-explanatory.
