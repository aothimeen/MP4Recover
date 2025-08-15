# MP4Recover

A simple web tool to recover broken mp4 files, using fix_avcC, ffmpeg, MP4Box, remoover, untrunc, reencode, etc.

https://mp4-recover.activetk.jp/

# Requirements

As this tool works on docker, all you need is just docker engine and docker compose.

Ask ChatGPT or Gemini how to install them:

```Bash
Yo GPT plz tell me how to install docker engine and docker compose on my computer
```

# Setup

## Step1. Clone the repository

```Bash
git clone https://github.com/ActiveTK/MP4Recover/
cd MP4Recover/
```

## Step2. Run `build.bat` or `build.sh`

If you are using Windows, then use `build.bat` to build the docker image:

```Bash
./build.bat
```

For Linux or macOS users, run `build.sh`:

```Bash
chmod +x build.sh
./build.sh
```

## Step3. Open browser and go to localhost:8080

Now you can use your own MP4Recover on https://localhost:8080/ . 

The port number depends on your `docker-compose.yml`.

# License

This program is released under the MIT License.

© 2025 ActiveTK.  
🔗 https://github.com/ActiveTK/gff/blob/master/LICENSE
