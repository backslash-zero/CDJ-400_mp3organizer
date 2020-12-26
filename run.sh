#!/bin/bash

# MIT License
#
# Copyright (c) 2020 Célestin Meunier
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

arg_checks()
{
    if [[ $# -eq 0 ]] ;
    then
        echo "No arguments supplied"
        exit 1
    fi
}

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
    fi
}

enable_globstar()
{
    grep -Fxq "shopt -s globstar" ~/.bashrc;
    if [ $? -eq 1 ]
    then
        echo "shopt -s globstar" >> ~/.bashrc;
        echo "globstar enabled in ~/.bashrc";
    fi
}

# arg_checks;
enable_globstar;
check_install_realpath;
cd $1;
cleanup_file_names;

# main loop
find . -type f \( -name "*.m4a" -or -name "*.mp3" \) -exec echo "{}" \;|
while IFS= read -r file;
do
        format=`echo ${file:(-4)}`;
        file_abs=`echo $(realpath "$file")`;
        file_dir=${file_abs%'/'*};
        title=`ffprobe -loglevel error -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "$file"` 
        artist=`ffprobe -loglevel error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$file"` 
        if [[ $format == ".m4a" ]];
        then
            newfile="${file_dir}/tmp.mp3"
            ffmpeg -i "$file" -hide_banner -loglevel fatal -c:a libmp3lame -q:a 8 "$newfile" -nostdin 2>&1 > /dev/null
            rm $file;
        else
            newfile=$file
        fi
        bpm-tag -f $newfile 2>&1 > /dev/null
        bpm=`ffprobe -loglevel error -show_entries format_tags=TBPM -of default=noprint_wrappers=1:nokey=1 "$newfile"` 2>&1 > /dev/null
        bpm=${bpm%.*};
        bpm=`printf %03d $bpm`
        mv $newfile "${file_dir}/${bpm}-${artist}-${title}.mp3";
        echo "✅ Created new file: ${bpm}-${artist}-${title}.mp3"
done
