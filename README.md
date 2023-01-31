# TVB Reconstruction Pipeline on o<sup>2</sup>S<sup>2</sup>PARC

This repository contains the source code for the o<sup>2</sup>S<sup>2</sup>PARC service of the The Virtual Brain Reconstruction pipeline (tvb-recon). Please visit the [tvb-recon repository](https://github.com/the-virtual-brain/tvb-recon) for more information.

## How to create and test the Service

```console
$ make help

$ make devenv
$ source .venv/bin/activate

(.venv)$ make build
(.venv)$ make info-build
(.venv)$ make tests
```

## Some important files

1. The [Dockerfile](tvb-recon/src/Dockerfile) was modified starting from the base `tvb-recon` Docker image
2. The [.osparc](.osparc) is the configuration folder and source of truth for metadata: describes service info and expected inputs/outputs of the service.
3. The [execute](tvb-recon/service.cli/execute) shell script was modified to run the service using the expected inputs and retrieve the expected outputs.
4. The test input/output were not included with the service code, since they are large files. Ask the mainteners for more information.
5. The service docker image may be built and tested as ``make build tests`` (see usage above)


---
<p align="center">
<image src="https://github.com/ITISFoundation/osparc-simcore-python-client/blob/4e8b18494f3191d55f6692a6a605818aeeb83f95/docs/_media/mwl.png" alt="Made with love at www.z43.swiss" width="20%" />
</p>
