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

Replicate file structure of my playlists, converting everything to mp3 and renaming each file adding BPM info as a prefix. We can also take full advantage of id3v2 tags like track _title_ and _artist_

`${file_dir}/${bpm}-${artist}-${title}.mp3`

BPM data should be displayed in a three digit format, so that they are automatically ordered incrementaly:
- 090 
- 125
- 140

## How does it work

For every file:
- Converting to Mp3 if not done already
- Get BPM and add to meta-tag and as a prefix to filename.

## Example
```
├── 0 The Beatles - ,All My Loving.m4a
├── 01 Meditation 4.mp3
├── 18 All You Need Is Love.m4a
├── 3-08 All I Need.mp3
├── folder1
│   ├── 10 Alberto Balsalm.mp3
│   └── AkaFrank ft. Jay Ant, Iamsu! - Lots [Prod. HIMTB Music] [Thizzler.com].m4a
├── folder2
│   ├── 0 The Beatles - ,All My Loving.m4a
│   ├── 18 All You Need Is Love.m4a
│   ├── 3-08 All I Need.mp3
│   └── folder3
│       ├── 0 The Beatles - ,All My Loving.m4a
│       ├── 18 All You Need Is Love.m4a
│       └── 3-08 All I Need.mp3
└── folder3
    ├── 0 The Beatles - ,All My Loving.m4a
    ├── 18 All You Need Is Love.m4a
    └── 3-08 All I Need.mp3
```
becomes
```
├── 093-Re:jazz Feat. Lisa Bassenge-All I Need.mp3
├── 105-The Beatles-All You Need Is Love.mp3
├── 126-Melchior Productions Ltd.-Meditation 4.mp3
├── 139-The Beatles-All My Loving.mp3
├── folder1
│   ├── 093-Aphex Twin-Alberto Balsalm.mp3
│   └── 093-Thizzler On The Roof-AkaFrank ft. Jay Ant, Iamsu! - Lots [Prod. HIMTB Music] [Thizzler.com].mp3
├── folder2
│   ├── 093-Re:jazz Feat. Lisa Bassenge-All I Need.mp3
│   ├── 105-The Beatles-All You Need Is Love.mp3
│   ├── 139-The Beatles-All My Loving.mp3
│   └── folder3
│       ├── 093-Re:jazz Feat. Lisa Bassenge-All I Need.mp3
│       ├── 105-The Beatles-All You Need Is Love.mp3
│       └── 139-The Beatles-All My Loving.mp3
└── folder3
    ├── 093-Re:jazz Feat. Lisa Bassenge-All I Need.mp3
    ├── 105-The Beatles-All You Need Is Love.mp3
    └── 139-The Beatles-All My Loving.mp3
```

## Dependencies (auto installed)

- FFmpeg: https://github.com/FFmpeg/FFmpeg
- bpm-tag: http://www.pogo.org.uk/~mark/bpm-tools/