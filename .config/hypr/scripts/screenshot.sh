#!/usr/bin/env bash
# Screenshot: select area and copy to clipboard
grim -g "$(slurp)" - | wl-copy
