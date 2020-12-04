#!/bin/bash

find "/tmp/ramdisk/tidal" -cmin +5 -iname "album.json" -exec "/tmp/ramdisk/RedSea/postproc-flac.sh" "{}" \;
