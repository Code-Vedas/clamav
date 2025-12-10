# ClamAV Docker Image

This repository contains a Dockerfile for building a Docker image of ClamAV, an open-source antivirus engine for detecting trojans, viruses, malware, and other malicious threats.

## Building the Docker Image

To build the Docker image, navigate to the `clamav` directory and run the following command:

```bash
cd clamav
docker build -t TAG .
```

Replace `TAG` with your desired image tag.

## Pushing the Docker Image
To push the Docker image to a container registry, use the following command:

```bash
docker push TAG
```

Replace `TAG` with the tag you used when building the image.

## Github images

The Docker image is also available on GitHub Container Registry at the following URL:

```
ghcr.io/codevedas/clamav
```
You can pull the image using the following command:

```bash
docker pull ghcr.io/code-vedas/clamav:main
```

# Disclaimer

This Docker image is not officially affiliated with or endorsed by the ClamAV project. It is provided as-is for convenience and may not include all features or configurations of the official ClamAV distribution. Users are advised to review and modify the Dockerfile as needed to suit their specific requirements.

# License

The Dockerfile and associated files in this repository are licensed MIT License. ClamAV itself is licensed under the GNU General Public License v2.0 (GPL-2.0). 

The resulting container image includes ClamAV, which is licensed under GPL-2.0.
Source: https://github.com/Cisco-Talos/clamav
