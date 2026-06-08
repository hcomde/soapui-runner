# SoapUI Runner

This project is a docker image for running functional SoapUI tests in a docker container. 
The image contains **SoapUI 5.9.1** running on **amazoncorretto:17** docker image. 

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

### Update SoapUI and CI/CD

To update SoapUI, update the `Dockerfile` the most recent stable and fully released version for 
- [SoapUI](https://www.soapui.org/downloads/latest-release/)
- [MySql Connector/J](https://dev.mysql.com/downloads/connector/j/)
- [Amazon Corretto](https://aws.amazon.com/corretto/)
  - Check the compatibility between SoapUI and Java. At the moment, the latest Java version supported by SoapUI is Java 17, so Amazon Corretto 17 is kept.

The GitHub Actions in the CI/CD pipeline are kept up to date to ensure compatibility with newer Node.js runners. 
Check the repositories for the latest version and update them in `build_test_deploy.yml` if necessary.

Currently, the following actions used:
- `actions/checkout`, Repository can be found [here](https://github.com/actions/checkout)
- `actions/upload-artifact`, Repository can be found [here](https://github.com/actions/upload-artifact)
- `actions/download-artifact`, Repository can be found [here](https://github.com/actions/download-artifact)
- `docker/login-action`, Repository can be found [here](https://github.com/marketplace/actions/docker-login)

Because of a deprecation issue with Node, GitHub warned about version mismatches. To use Node.js 24, it was recommended to add this flag: `env: FORCE_JAVASCRIPT_ACTIONS_TO_NODE24: true`. 
This can be removed when Node.js 24 is set as default, which should be June 16th, 2026, according to GitHubs documentation.

For more information see: https://github.blog/changelog/2025-09-19-deprecation-of-node-20-on-github-actions-runners/


Commit and push with a tag `[SoapUI-Version]-alpha`, then check the GitHub workflow if Build and Push are successful. 
If they fail, fix the issue and add a new tag, e.g. `[SoapUI-Version]-alpha2`, until the workflow passes. 
If the workflow passes, add a tag with the new `[SoapUI-Version]`.


Edit in project `hoyailog` the `.env` file and update the SoapUI version under the docker tag `HOYAILOG_SOAPUI_DOCKER_TAG`.
Also edit `docker-compose-mockservices.yml` and add the new SoapUI version for the Soap mock services. 

Then execute the SoapUI test run in TeamCity and check if the correct version of SoapUI is executed. 
In the logs, there should be a line `Image ghcr.io/hcomde/soapui-runner:[SoapUI-Version] Pulling`.

## Credit
Credit goes to 
 - [Fabian Jocks](https://github.com/iamfj)
 - [Karla Scholz](https://github.com/karlascholz-hcom)
 - Robin Matz ([robinmatz/soapui-runner](https://github.com/robinmatz/soapui-runner))
 - Luka Stosic ([lukastosic/docker-soapui](https://hub.docker.com/r/lukastosic/docker-soapui))
 - Daniel Davison ([ddavison/soapui](https://hub.docker.com/r/ddavison/soapui))
