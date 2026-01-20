# SoapUI Runner

This project is a docker image for running functional SoapUI tests in a docker container. The image contains 
**SoapUI 5.9.1** running on **amazoncorretto:25** docker image. 

## Extensions

The SoapUI image is equipped with a [MySQL Connector](https://dev.mysql.com/downloads/connector/j/) extension.

## Usage

The basic structure for running SoapUI tests is the following:

```
docker run -i --rm \
    -v <path_to_your_soapui_project>:/opt/soapui/projects \
    -v <path_to_your_reports_folder>:/opt/soapui/projects/reports \
    ghcr.io/hcomde/soapui-runner:<tag> \
    -<soapui_options(optional)> \
    -I "<path_to_your_soapui_project>"
```

The ``docker run -i -rm`` command will run the container (``-i argument``), print the output on terminal and removes 
anonymous volumes associated with the container (``-rm argument``).

Since the container uses ``testrunner.sh`` as ``ENTRYPOINT``, SoapUI CLI arguments will have to be specified. You can 
find a list of all supported arguments [here](https://www.soapui.org/docs/test-automation/running-functional-tests/).

### Example

```
docker run -i -rm \
    -v ${PWD}/test:/opt/soapui/projects \
    -v ${PWD}/reports:/opt/soapui/projects/reports \
      ghcr.io/hcomde/soapui-runner:latest \
        -r -j -f /opt/soapui/projects/reports \
        -I /opt/soapui/projects/TestProject-soapui-project.xml
```

``${PWD}`` gives you the current working directory. This is quite handy when running your tests in different 
environments, such as your local machine and CI-pipelines. The ``-r argument`` prints a small report on the console. 
The ``-j argument`` creates a JUnit XML report. The ``-f argument`` lets you specify the output folder of your test 
reports. Note that here you will have to specify the folder in the **docker container**. Last, the ``-I argument`` 
requires the path to the soapui-project.xml file. This path also refers to the path in the **docker container**.

## Credit
Credit goes to 
 - [Fabian Jocks](https://github.com/iamfj)
 - Robin Matz ([robinmatz/soapui-runner](https://github.com/robinmatz/soapui-runner))
 - Luka Stosic ([lukastosic/docker-soapui](https://hub.docker.com/r/lukastosic/docker-soapui))
 - Daniel Davison ([ddavison/soapui](https://hub.docker.com/r/ddavison/soapui))
