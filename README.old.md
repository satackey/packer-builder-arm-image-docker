# Packer plugin for ARM images __running on Docker__

## Usage

- See the [upstream repo](https://github.com/solo-io/packer-builder-arm-image) for detailed usage.

<!-- ### Running -->

```bash
$ docker run \
    # Mount packerfile dir and the image will be generated here
    -v /path/to/packerfile/dir:/img \
    # Specify relative path from /img dir (in container)
    -e PACKERFILE=relative/path/to/packerfile.json \
    # To use binfmt
    --privileged \
    # Remove container after building
    --rm
    $(docker build -q .)
```

### Example

```bash
$ docker run -e PACKERFILE=example.json -v ${PWD}:/img --privileged --rm $(docker build -q .)
arm-image output will be in this color.

==> arm-image: Downloading or copying Image
    arm-image: Downloading or copying: raspbian-buster-lite.zip
==> arm-image: Copying source image.
==> arm-image: Image is a zip file.
==> arm-image: Unzipping raspbian-buster-lite.img
    arm-image: mappping output-arm-image/image

...some outputs

Build 'arm-image' finished.

==> Builds finished. The artifacts of successful builds are:
--> arm-image: output-arm-image/image
```

The image is saved with the same name as `$PACKERFILE` without the extension.

### Caching

If you want to cache the download,
create volume and mount `/root/packer_cache` on it.

```bash
$ docker volume create packer_cache
$ docker run -e PACKERFILE=example.json -v ${PWD}:/img -v packer_cache:/root/packer_cache --privileged --rm $(docker build -q .)
```
