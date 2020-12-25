#!/bin/bash

cleanup_file_names()
{
    SAVEIFS=$IFS; IFS=$(echo -en "\n\b"); for i in $(find . -type f  -name "*[\!\,\[\]\;\>\<\@\$\#\&\(\)\?\\\%\ ]*"); do mv "$i" ${i//[][!,\;><\@\$\#\&\(\)\?\\\%\ ]/_}; done; IFS=$SAVEIFS
}

check_installs_bpm()
{
    if ! command -v bpm-tag &> /dev/null
    then 
        echo "bpm-tag not installed"
        echo "trying homebrew install..."
        brew install bpm-tools > /dev/null 2>&1
        if [$? -eq 1]
        then
            echo "there was a problem installing bpm-tools"
            exit 1;
        else
            echo "Success"
        fi
    fi
    if ! command -v id3v2 &> /dev/null
    then 
        echo "id3v2 not installed"
        echo "trying homebrew install..."
        brew install id3v2 > /dev/null 2>&1
        if [$? -eq 1]
        then
            echo "there was a problem installing id3v2"
            exit 1;
        else
            echo "Success"
        fi
    fi
    if ! command -v sox &> /dev/null
    then 
        echo "id3v2 not installed"
        echo "trying homebrew install..."
        brew install sox > /dev/null 2>&1
        if [$? -eq 1]
        then
            echo "there was a problem installing sox"
            exit 1;
        else
            echo "Success"
        fi
    fi
}

check_install_realpath()
{
    if ! command -v realpath &> /dev/null
    then 
        echo "realpath not installed"
        echo "trying homebrew install..."
        brew install coreutils > /dev/null 2>&1
        if [$? -eq 1]
        then
            echo "there was a problem installing coreutils"
            exit 1;
        else
            echo "Success"
        fi
    fi
}

press_enter_to_continue()
{
    printf 'press [ENTER] to continue...'
    read _
}

enable_dotglob()
{
    grep -Fxq "shopt -s dotglob" ~/.bashrc;
    if [ $? -eq 1 ]
    then
        echo "shopt -s dotglob" >> ~/.bashrc;
        echo "dotglob enabled in ~/.bashrc";
    else
        echo "dotglob already enabled in ~/.bashrc";
    fi
}

enable_globstar()
{
    grep -Fxq "shopt -s globstar" ~/.bashrc;
    if [ $? -eq 1 ]
    then
        echo "shopt -s globstar" >> ~/.bashrc;
        echo "globstar enabled in ~/.bashrc";
    else
        echo "globstar already enabled in ~/.bashrc";
    fi
}

base=`pwd`
enable_globstar;
check_install_realpath;
press_enter_to_continue;
cd $1;
cleanup_file_names;
press_enter_to_continue;
find . -type f \( -name "*.m4a" -or -name "*.mp3" \) -exec echo "{}" \;|
while IFS= read -r file;
do
        echo "file: $file";
        format=`echo ${file:(-4)}`;
        echo "format: $format";
        file_abs=`echo $(realpath "$file")`;
        echo "file abs: $file_abs";
        file_dir=${file_abs%'/'*};
        echo "dir: $file_dir";
        title=`ffprobe -loglevel error -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "$file"`;
        artist=`ffprobe -loglevel error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$file"`;
        bpm-tag -f $file 2>&1
        bpm=`ffprobe -loglevel error -show_entries format_tags=TBPM -of default=noprint_wrappers=1:nokey=1 "$file"`;
        bpm=${bpm%.*};
        bpm=`printf %03d $bpm`
        echo "title: $title";
        echo "artist: $artist";
        echo "bpm: $bpm";
        if [[ $format == ".m4a" ]];
        then
            ffmpeg -i "$file" -hide_banner -c:a libmp3lame -q:a 8 "${file_dir}/${bpm}-${artist}-${title}.mp3" -nostdin;
            rm $file;
        else
            mv $file "${file_dir}/${bpm}-${artist}-${title}.mp3";
        fi
done
