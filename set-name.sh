#! /bin/sh

# MIT License
#
# Copyright (c) 2024 Giovanni Santini
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
#
# ---------------------------------------------------------------------------- #
# 
# This script is part of the modern cpp template project. It is used to set the
# name of the project and update all the files that contain the old name.
#
# ---------------------------------------------------------------------------- #

if [ $# -ne 1 ]; then
    echo "Usage: $0 <project-name>"
    exit 1
fi

PROJECT_NAME=$1
echo "Setting project name to $PROJECT_NAME"

# ${PROJECT_NAME,,} Lowercase
# ${PROJECT_NAME^^} Uppercase

echo "Substituting names..."
grep -r "pc" -l --exclude-dir=".git/" | tr '\n' ' ' | xargs sed -i "s/pc/${PROJECT_NAME,,}/g"
grep -r "PC" -l --exclude-dir=".git/" | tr '\n' ' ' | xargs sed -i "s/PC/${PROJECT_NAME^^}/g"

echo "Renaming files..."
if [ -d "src/mylib" ]; then
        mv src/mylib src/${PROJECT_NAME,,}
fi
find . -type f -name '*mylib*' -path "./git" -prune | while read file; do
        mv "$file" "${file//mylib/$PROJECT_NAME}";
done

echo "Done"
