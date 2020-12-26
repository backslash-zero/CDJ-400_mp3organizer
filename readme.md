# CDJ-400 Mp3 Organizer

## Usage

```
./run.sh repository-path
```

## Problem

Pioneers CDJ 400 are digital music players for djying, and were the first model able to play tracks from a USB drive.
They are quite common and cheap but are somewhat limited compared to current days CDJs.

Main limitations being:
- UI, only able to display file names and folders, by alphabetical order, on a tiny led screen.
- BPM is a crucial datapoint for selecting tracks in a DJ set and is not being displayed.
- Only supported file format is mp3.

![CDj-400](https://www.pioneerdj.com/-/media/pioneerdj/images/products/player/cdj-400/cdj-400-main.png?h=240&w=320&hash=629C95F1CF6F54AB9D0EBA5717579B6E.png)

## Proposed Solution

Replicate file structure of my playlists, converting everything to mp3 and renaming each file adding BPM info as a prefix.

BPM data should be displayed in a three digit format, so that they are automatically ordered incrementaly:
- 090 
- 125
- 140

## How does it work

For every file:
- Converting to Mp3 if not done already
- Get BPM and add to meta-tag and as a prefix to filename.

## Dependencies (auto installed)

- FFmpeg: https://github.com/FFmpeg/FFmpeg
- bpm-tag: http://www.pogo.org.uk/~mark/bpm-tools/