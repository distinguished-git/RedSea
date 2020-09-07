RedSea
======
Music downloader and tagger for Tidal. For educational use only, and may break in the future.

Current state
-------------
This fork is currently maintained by me ([Dniel97](https://github.com/Dniel97))

Telegram
--------
Join the telegram group [RedSea Community](https://t.me/RedSea_Community) if you have questions, want to get help,
submit bugs or want to talk to the developer.

Introduction
------------
RedSea is a music downloader and tagger for the Tidal music streaming service. It is designed partially as a Tidal API example. This repository also hosts a wildly incomplete Python Tidal
API implementation - it is contained in `redsea/tidal_api.py` and only requires `requests` to be installed.

Supported Codecs
----------------
Tidal has a few different codecs it supports (only music is covered here)

Quick glossary:\
EAC-3: Actually Dolby EAC-3 JOC aka Dolby Digital Plus with Dolby Atmos (Lossy)\
AC-4: Dolby AC-4 (Lossy)\
360: 360 Reality Audio on Tidal, actually the MPEG-H codec (Lossy)\
MQA: Master Quality Authenticated in the FLAC container (Lossy)\
FLAC: Free Lossless Audio Codec, the most popular lossless audio codec by far (Lossless)\
ALAC: Apple Lossless [Audio Codec], similar to FLAC (Lossless)\
AAC: Advanced Audio Coding, designed as a successor to MP3 (Lossy)

Quality of these codecs from highest to lowest:\
Normal listening
1. MQA (even though it is lossy and highly debatable, a normal lossless 16 bit FLAC can be extracted, so it wins by technicality)
2. FLAC (16 bit, 44.1kHz)/ALAC (both are lossless and can be converted from one another without loss)
3. AAC (96 or 320 kbps depending on selected quality, 320 being higher quality, variable bitrate (VBR)) 

Immersive surround sound listening:
1. EAC-3 (based on 5.1 surround with Dolby Atmos metadata added, 768kbps bitrate but it is a significantly less efficient than AC-4 and it has more channels so quality is debatable)
2. AC-4 (based on stereo (2.0 not surround) with Dolby Atmos metadata added, 256kbps bitrate)
3. 360 (garbage in testing, though untested with actual supported headphones so it may actually be great)

Client IDs (also called tokens, X-Tidal-Token)
--------------------
Different devices are allocated different tokens, and are only allowed to retrieve specific codecs. Tidal has a relatively complex system of handling these. No way near as complex as Amazon's system, but still:

Supported Codecs with an Android TV login:\
Most client IDs: MQA, FLAC, AAC\
NVIDIA Shield TV 2019, Amazon FireTV, some actual TVs that run Android: MQA, FLAC, AAC plus EAC-3 (theoretically nearly every Android TV should be able to support EAC-3, but Tidal does not allow them)

Supported Codecs with an Android Mobile login:\
Most client IDs: MQA, FLAC, AAC, 360\
Devices with a dedicated AC-4 hardware decoder: MQA, FLAC, AAC, 360 plus AC-4

iOS: MQA, ALAC, AAC, 360\
tvOS: The specifics are unknown but we do know it uses MPEG-DASH streaming\
macOS: ALAC, AAC\
Desktop: MQA, FLAC, AAC (MQA is encrypted with extremely basic encryption, handled by RedSea fine, though the client ID (token) currently used by default does not support MQA)\
Browser: FLAC, AAC

Therefore:
* To get the EAC-3 codec version of Dolby Atmos Music, the TV sign in must be used with the client ID and secret of one of the supported Android TVs (full list below) (bring your own TV client ID and secret)
* To get the AC-4 codec version of Dolby Atmos music, the Mobile sign in must be used with the client ID of one of the supported phones (default mobile works)
* To get MQA, use literally anything that is not the browser, nearly all client IDs work. (In this case change the client ID of the desktop login) (bring your own anything (TV, mobile, desktop))
* To get ALAC without conversion, use the client ID of an iOS device, or the optional desktop token included from macOS (comment out the default FLAC supporting one, and uncomment the ALAC one) (secondary desktop works, or bring your own mobile)
* To get 360, use the client ID of a supported Android or iOS device (nearly all support it anyway, so that's easy) (default mobile works)

Client IDs provided by default:
* TV: FireTV without EAC-3 support
* Mobile: Default has AC-4 support (which also supports MQA by extension). There is also another one which only supports MQA without AC-4 optionally (commented out)
* Desktop: Neither of the included ones support MQA! You must replace it with your own if you want MQA support! Default token can get FLACs only, whereas the optional one can get ALACs only (both are also able to get AAC)
* Browser: Is completely unsupported for now, though why would you want it anyway?

Note: Currently, mobile login is broken due to a recent change server-side on Tidal's end to validate reCAPTCHA responses finally, thus ending the saga unless we find a method to generate these responses automatically (unlikely)

Further Reading on supported devices and codecs:
* https://support.tidal.com/hc/en-us/articles/360004255778-Dolby-Atmos-Music (full up to date list of supported Android TVs for EAC-3 JOC)
* https://github.com/google/ExoPlayer/issues/6667#issuecomment-555845608 (Android phones that are actually capable of decoding AC-4, slightly outdated)
* https://www.dolby.com/experience/tidal/#tidal%20devices (some devices that support Dolby Atmos, missing a few devices that Tidal does actually support, but relatively up-to-date)
* https://avid.secure.force.com/pkb/articles/en_US/faq/AvidPlay-Distributing-Dolby-Atmos-Music-FAQ (bitrates and other background information, really interesting)

Retrieving your client ID
-------------------------
Note: Android TVs use a slightly different system of client IDs plus client secrets, and the only way to retrieve EAC-3s is to root an NVIDIA Shield TV 2019, which is extremely complex and comes with its own issues, to get its client ID and secret, as none of the supported devices can have user certificates installed, and the NVIDIA Shield TV is the only one that can be rooted to do this.

To get a client ID, you must do a man-in-the-middle-attack or otherwise. On Android this involves getting Tidal to accept user certificates. This can be done in two ways:
1. Somehow modify the APK to add the certificate in yourself (difficult!)
2. Force it to target Android Marshmallow (6.0, API 23) as it is the last version that user certificates are allowed

Requirements
------------
* Python (3.6 or higher)
* requests
* mutagen (1.37 or higher)
* pycryptodomex
* ffmpeg-python (0.2.0 or higher)
* deezerapi (already included from [deemix](https://codeberg.org/RemixDev/deemix))


First setup
-----------
After downloading RedSea, copy `config/settings.example.py` and rename it to `config/settings.py`, now you can set all your preferences inside `settings.py`.

#### Linux:
1. Run `sudo apt update` 
2. Run `sudo apt install ffmpeg`

#### MacOS:
1. If you haven't already installed Homebew: Run `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`
2. Run `brew install ffmpeg`

#### Windows:
1. Download [ffmpeg](https://ffmpeg.zeranoe.com/builds/)
2. Unpack the zip folder `ffmpeg-XXXXX-win64-static.zip` inside `C:\Program Files\ffmpeg\`
3. Go to `Control Panel > System and Security > System > Advanced system settings > Environment Variables ...`
4. In the Environment Variables window, click the `Path` row under the `Variable` column, then click `Edit..`
5. Click on `New` inside the `Edit environment variable` window and paste `C:\Program Files\ffmpeg\bin\`

Setting up (with pip)
------------------------
1. Run `pip install -r requirements.txt` to install dependencies
2. Run `python redsea.py -h` to view the help file
3. Run `python redsea.py urls` to download lossless files from urls
4. Run `python redsea.py --file links.txt` to download tracks/albums/artists/ from a file where each line is a link

Setting up (with Pipenv)
------------------------
1. Run `pipenv install --three` to install dependencies in a virtual env using Pipenv
2. Run `pipenv run python redsea.py -h` to view the help file
3. Run `pipenv run python redsea.py urls` to download lossless files from urls

How to add accounts/sessions
----------------------------
    usage:  redsea.py auth list
            redsea.py auth add
            redsea.py auth remove
            redsea.py auth default
            redsea.py auth reauth

    positional arguments:

    list                Lists stored sessions if any exist

    add                 Prompts for a TV or Mobile session. The TV option
                        displays a 6 digit key which should be entered inside 
                        link.tidal.com where the user can login. The Mobile option
                        prompts for a Tidal username and password. Both options
                        authorize a session which then gets stored in
                        the sessions file

    remove              Removes a stored session from the sessions file
                        by name

    default             Set a default account for redsea to use when the
                        -a flag has not been passed

    reauth              Reauthenticates with server to get new sessionId

How to use
----------
    usage: redsea.py [-h] [-p PRESET] [-a ACCOUNT] [-s] [--file FILE] urls [urls ...]

    A music downloader for Tidal.

    positional arguments:
    urls                    The URLs to download. You may need to wrap the URLs in
                            double quotes if you have issues downloading.

    optional arguments:
    -h, --help              show this help message and exit
    -p PRESET, --preset PRESET
                            Select a download preset. Defaults to Lossless only.
                            See /config/settings.py for presets
    -a ACCOUNT, --account ACCOUNT
                            Select a session/account to use. Defaults to
                            the "default" session. If it does not exist, you
                            will be prompted to create one
    -s, --skip              Pass this flag to skip track and continue when a track
                            does not meet the requested quality
    -f, --file              The URLs to download inside a .txt file with a single 
                            track/album/artist each line.

#### Searching

Searching for tracks, albums and videos is now supported.

Usage:      `python redsea.py search [track/album/video] [name of song/video, spaces are allowed]`

Example:    `python redsea.py search video Darkside Alan Walker`

#### ID downloading

Download an album/track/artist/video/playlist with just the ID instead of an URL

Usage:      `python redsea.py id [album/track/artist/video/playlist ID]`

Example:    `python redsea.py id id 92265335`

#### Exploring

Exploring new Dolby Atmos or 360 Reality Audio releases is now supported

Usage:      `python redsea.py explore (dolby atmos/sony 360)`

Example:    `python redsea.py explore dolby atmos`

Lyrics Support
--------------
Redsea supports retrieving synchronized lyrics from the services LyricFind via Deezer, and Musixmatch, automatically falling back if one doesn't have lyrics, depending on the configuration

Tidal issues
------------
* Sometimes, tracks will be tagged with a useless version (for instance, "(album version)"), or have the same version twice "(album version)(album version)". This is because tracks in
    Tidal are not consistent in terms of metadata - sometimes a version may be included in the track title, included in the version field, or both.
    
* Tracks may be tagged with an inaccurate release year; this may be because of Tidal only having the "rerelease" or "remastered" version but showing it as the original.

To do/Whishlist
---------------
* ~~ID based downloading (check if ID is a track, album, video, ...)~~
* Complete `mediadownloader.py` rewrite
* Move lyrics support to tagger.py
* Support for being used as a python module (maybe pip?)
* Maybe Spotify playlist support
* Artist album/video download (which downloads all albums/videos from a given artist)

Config reference
----------------

`BRUTEFORCEREGION`: When True, redsea will iterate through every available account and attempt to download when the default or specified session fails to download the release

### `Stock Presets`

`default`: FLAC 44.1k / 16bit only

`best_available`: Download the highest available quality (MQA > FLAC > 320 > 96)

`mqa_flac`: Accept both MQA 24bit and FLAC 16bit

`MQA`: Only allow FLAC 44.1k / 24bit (includes 'folded' 96k content)

`FLAC`: FLAC 44.1k / 16bit only

`320`: AAC ~320 VBR only

`96`: AAC ~96 VBR only


### `Preset Configuration Variables`

`keep_cover_jpg`: Whether to keep the cover.jpg file in the album directory

`embed_album_art`: Whether to embed album art or not into the file.

`save_album_json`: save the album metadata as a json file

`tries`: How many times to attempt to get a valid stream URL.

`path`: Base download directory

`convert_to_alac`: Converts a .flac file to an ALAC .m4a file (requires ffmpeg)

`lyrics`: Enable lyrics tagging and synced lyrics as .lrc download using the Deezer API (from [deemix](https://codeberg.org/RemixDev/deemix)) or musiXmatch

`lyrics_provider_order`: Defines the order (from left to right) you want to get the lyrics from

`artwork_size`: Downloads (artwork_size)x(artwork_size) album covers from iTunes

`resolution`: Which resolution you want to download the videos

Format variables are `{title}`, `{artist}`, `{album}`, `{tracknumber}`, `{discnumber}`, `{date}`, `{quality}`, `{explicit}`.

* `{quality}` has a whitespace in front, so it will look like this " [Dolby Atmos]", " [360]" or " [M]" according to the downloaded quality

* `{explicit}` has a whitespace in front, so it will look like this " [E]"

`track_format`: How tracks are formatted. The relevant extension is appended to the end.

`album_format`: Base album directory - tracks and cover art are stored here. May have slashes in it, for instance {artist}/{album}.
