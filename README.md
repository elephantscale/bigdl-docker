# Analytics Zoo Tutorials
<img src="images/bigdl-logo-bw.jpg"/>

This repository contains tutorials and examples of Intel Analytics Zoo software.

## Contents
- [About Analytics Zoo](#about)
- [Tutorials](#autorials)
- [Running Analytics Zoo](#running)
- [Building Docker container](#building)



## About Analytics Zoo
Analytics Zoo is a Deep Learning framework.  
TODO add more.  
You can find more below
- [Analytics Zoo product page](https://software.intel.com/en-us/blogs/2018/09/10/analytics-zoo-unifying-analytics-ai-for-apache-spark)
- [Analytics Zoo @ Github](https://github.com/intel-analytics/analytics-zoo)

## Tutorials
- [Tutorial 1](tutorials/tutorial1.md)
- [Tutorial 2](tutorials/tutorial2.md)

## Running
We have an easy to use Docker container with Analytics Zoo and all dependencies and utilities needed.

#### Step 1:
Install [Docker](https://www.docker.com/) for your platform

#### Step 2:
Download [this repository](https://github.com/elephantscale/bigdl-tutorials) to your machine.  
You can either use
```
    $    git clone https://github.com/elephantscale/bigdl-tutorials
```
or download the repository as a zip file and unzip it.

#### Step 3:
Go into your directory and launch the following command
```
    $    ./run-bigdl-docker.sh   elephantscale/bigdl-docker
    # $    ./run-bigdl-docker.sh   <image id>
```
This will launch the Docker container and run Jupyter notebook

#### Step 4:
Go to Jupyter notebook url displayed on the console, it will look like
`http://localhost:8888?token=abcdef12345`

#### Step 5:
Navigate to `work` directory and you will see notebook tutorials.

Note : Please do all the work in the `work` directory.  Any work you do in `work` directory will be saved automatically on your machine.  And the changes will be available even after Docker container has exited.

<img src="images/docker1.png"/>


## Building
If you'd like to build your own version of Docker container, please see instructions in [docker/README.md](docker/README.md)
