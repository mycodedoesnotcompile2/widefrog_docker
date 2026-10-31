widefrog docker image
---------------------
Ready-made docker image of widefrog tool by user `2nHxWW6GkN1l916N3ayz8HQoi` from ["forum.videohelp.com"](https://forum.videohelp.com/threads/414548-drm-free-content-batch-downloader-widefrog).

Features
--------
Based on Debian 13
Built for [`x64` and `arm64`](https://github.com/mycodedoesnotcompile2/widefrog_docker/packages)

Usage
-----
```
# Execute the docker image
$ docker run -it ghcr.io/mycodedoesnotcompile2/widefrog:latest

# Provide your credentials for the platform you want to download from
$ cd /opt/widefrog
$ vim app_files/config.json

# Download content
$ python widefrog.py "url"

# If you encounter errors, add "--debug"
$ python widefrog.py --debug "url"

# If you need to bypass geo-restrictions
Edit "/etc/tor/torrc" and add a "ExitNodes" directive, for instance "ExitNodes {es}" to appear from Spain
$ vim "/etc/tor/torrc"
$ service tor start
$ torsocks python widefrog.py "url"

# Finally, the downloaded medias are in "/opt/widefrog/media/"
$ ls /opt/widefrog/media/

# FYI, widefrog is installed in a Python virtualenv, if you get lost in the middle, just use "workoun venvwidefrog"
# Also, a bash alias named "widefrog" is provided.
```

See also
--------
* https://lafibre.info/tv-numerique-hd-3d/comment-telecharger-des-videos-sur-tf1-rmcbfmplay-ou-m6/
* https://ideenquelle.be/posts/widefrog/

