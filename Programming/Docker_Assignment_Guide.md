# A guide to the Hands-on session of Docker.
This session is done in Windows. Soon I will move to Ubuntu. In *italics* are written the questions, afterwards it is my answer.

## 1. Share data between the host and containers
*Use image: duartej/m1992-pyroot. Create some files inside the container and illustrate the different data sharing: in a running container, using docker cp and when starting the container, binding a volume to the host.*

### Binding mounts:
- Before anything else, I create two directories in `\C:`, one is called **VolumenDeCaye** and the other **CopiasDeCaye**. We will use them to not mix the different parts of the exercise.
- First of all, we open the Powershell as admin using right click.
- We open Docker Desktop to turn on the Docker Engine.
- We download the latest version of the image:

        docker pull duartej/m1992-pyroot
- We can make sure it is downloaded:

        docker images
- Now we can run the image binding a mount given a path (to know the absolute path of a directory we can use `tree <file>`) and also adding `/bin/bash` to enter the terminal inside the container and create some files we can see copied outside of it.

        docker run -v C:\VOLUMENDECAYE:/gate -it --rm duartej/m1992-pyroot:latest /bin/bash
**Note that the bars are inverted according to the OS: at the host the OS is Windows, but inside the container we are working with Linux distributions.**
- We can create now a sample file to check if the volume is correctly created (working in the terminal inside the container):
        
        touch kk.txt
- And check it is there with `ls` (list).
- Now we can exit the terminal inside the container: `CTRL+P, CTRL+Q`.
- If we wanted to get inside the container again it is enough to copy the name of the container and write:

        docker attach <name of the container>
### **Binding overwrites the container files**
In the case we have interest in some files inside the container (for example `duartej/m1992-pyroot` has a `.ipynb` and a `.pdf`) we should know that the binding option obscures the content inside the directory of the container we want to use. To solve this there are two options:
- 1. First running the container without binding anything, then copying the content of the gate to the folder we want to bind in the host and then running the image binding this folder to the gate:
                        
                docker run -it --rm duartej/m1992-pyroot:latest
                docker cp ecstatic_ramanujan:/gate C:\MONTURADECAYE
                docker run -v C:\MONTURADECAYE:/gate -it --rm duartej/m1992-pyroot:latest
- 2. **Danilo's solution!** Also we could just take profit on the fact that any directory in the path on the `-v <path in host>:<path in container>` that does not exist is going to be created, so we could create and overwrite an empty directory in just one step:
                
                docker run -v C:\MONTURADECAYE:/gate/CarpetaParaMontar -it --rm duartej/m1992-pyroot:latest
### Using the `cp` command:
- Now, using the same container we created, we can copy some files. Again, we need two paths:

        docker cp ecstatic_ramanujan:/gate C:\COPIASDECAYE
- If we check our folder `CopiasDeCaye` we can see it has a copy of the `gate` directory inside.
---
## 2. Installing missing packages
We create a new folder called **ArchivoDockerDeCaye** in `\C:` where we will save the dockerfile that was given in the moodle. It has no extension (there is an explicit option to chose no extension when saving the document) and it is called **Dockerfile**, but the name is pointless. In the case that we are executing Pyhton in interpreter mode we will need Xming to be on and not blocked by the Windows firewall, but to work with Jupyter it is not necessary.

*Use image: rocker/binder. Install several R packages (Hmisc) in the container.*
- We pull the new image:

        docker pull rocker/binder
- We run it prepared to be a jupyter notebook (`-p 8888:8888 -v gate:/gate` is precisely to do that):
        
        docker run -p 8888:8888 -v gate:/gate rocker/binder     
- Now open the notebook in the browser with the given url, create a new R notebook and use the R syntax to install the package `Hmisc` writing and running in that notebook:

        install.packages("Hmisc")
*Use exec to enter to a terminal of the container, usually as `--user root`.*
- Back in the terminal of the host, in a new window, we write (remember to not stop or kill the container!):
        
        docker exec --user root fervent_mclaren <command to enter>
*Use image: m1992-python. Install missing packages permanently (astropy, healpy).*
- We build the image `m1992-python` from the dockerfile. When we know the abolute path we write:

        docker build C:\ARCHIVODOCKERDECAYE
- We run it with a bash to avoid entering python3.9 automatically (the image is programmed to do so) and as USER root to allow installing packages (if using user root you will see `root@<container name or ID>:/gate#` in the terminal):
        
        docker run --user root -it --name caye-m1992-python 027f9d7572af /bin/bash
- We use the terminal inside the container to firstly update those packages (be sure that you are not in python, which is indicated by >>>):

        apt-get update
- And then to install the new ones:
        
        apt-get install python3-astropy
- And also:

        apt-get install python3-healpy
- Now we need to enter the container:

        docker attach caye-m1992-python
- Open python3.9:

        python3.9

- And import the desired packages (using python syntax). Note that the package is now called as `astropy` and not `python3-astropy` as the apt-get has it listed:

        >>> import astropy
- The same can be done with `healpy`:

        >>> import healpy
- We can check that they are installed with this code:

        >>> import pkg_resources
        installed_packages = pkg_resources.working_set
        installed_packages_list = sorted(["%s==%s" % (i.key, i.version)
                for i in installed_packages])
        print(installed_packages_list)
*Create/adapt the Dockerfile to incorporate the missing packages in the image.*
- We just find the following lines in the dockerfile:

        ...
            description="Docker image for M1992-Python with main scientific libraries"

        # -- Update and get needed packages
        USER root
        RUN apt-get update && apt-get install -y \
                python3-numpy \
                python3-matplotlib \
                python3-scipy \
                python3-pandas \
                # astropy \
                # healpy \
            && rm -rf /var/lib/apt/list/*

        # Avoid the kernel crashing likely due to the PID reaping problem
        ...
- And simply add to the list the needed libraries:
        
        ...
            description="Docker image for M1992-Python with main scientific libraries"

        # -- Update and get needed packages
        USER root
        RUN apt-get update && apt-get install -y \
                python3-numpy \
                python3-matplotlib \
                python3-scipy \
                python3-pandas \
                python3-astropy \
                python3-healpy \
            && rm -rf /var/lib/apt/list/*

        # Avoid the kernel crashing likely due to the PID reaping problem
        ...
---
## 3. Detach mode
*Containers can run interactively (then needs the `-it` options), and in detach mode, using the `-d` option. You can attach to a detached container with `attach` command. You can detach an interactive container using the CRTL^P CTRL^Q sequence.*
- We enter the interactive mode to use Python3 running the command we used before and it attachs us automaticaly:

        docker run -it 027f9d7572af
- But if run it in detach mode we do not get into the terminal of the container:

        docker run -it -d 027f9d7572af
- But we could attach whenever we want to use Python inside the container again (and exit the container terminal using `exit()`, which works because it is Python, or maybe the already used `CTRL+P, CTRL+Q`):

        docker attach wonderful_wilbur
---
## 4. Create a  jupyter notebook

*Use image: jupyter/base-notebook:2022-08-01 and create a running container binded to a local host folder.*
- We create a folder in `\C:` which is called **ParaLaLibreta**
- We pull the image:

        docker pull jupyter/base-notebook:2022-08-01
- We run it with the options we learned before: first, to be a notebook (`-p 8888:8888`) then to be binded to a volume (`-v <some absolute path in the host>:<some absolute path in the container>`):

        docker run -p 8888:8888 -v C:\PARALALIBRETA:/home/jovyan --name LibretaDelEj4 jupyter/base-notebook:2022-08-01
- We open the url in the web browser and we can start using the JupyterLab. **We can enter a terminal in the JupyterLab, use `pwd` and guess that the path this time is `/home/jovyan` and not `/gate` as before.** Also we can do this with the `bash` command.
---
## Some extra tips (some of them are repeated).
- With `CTRL+C` we can stop a process in the terminal.
- With `CTRL+P, CTRL+Q` we can exit the inside terminal of the container and come back to the host terminal.
- `pwd` (*print working directory*) is the tool used to know the path in Linux.
- To kill all the containers we can just use:

        sudo docker stop $(sudo docker ps -a -q)
- And to remove all the containers:

        sudo docker rm $(sudo docker ps -a -q)
- In Linux the best way to start working with JupyterLab with a mounted directory is using this already elaborated command:

        sudo  docker run -p 8888:8888 -v /home/cayesoneira/Notebooks:/home/jovyan/Mounted --name Libretas jupyter/base-notebook:2022-08-01
- And with a JupyterLab with Python and also R installed (we remove the name so we do not have to be erasing containers each time we want to run a JupyterLab):

        sudo  docker run -p 8888:8888 -v /home/cayesoneira/Notebooks:/home/jovyan/Mounted jupyter/datascience-notebook:latest
- To add a kernel we can write **in the terminal of the container** (we can access it through JupyterLab) the following (https://pypi.org/project/bash_kernel/):

        pip install bash_kernel
        python -m bash_kernel.install
