#!/bin/bash

# Copies the styleguide assets to keyframes-styleguide local repository.

TARGET_FOLDER=$HOME/Dev/webinative/keyframes-styleguide

if [ ! -d $TARGET_FOLDER ]; then
    echo "Error: Folder $TARGET_FOLDER not found."
    return 1
fi

CSS_SRC=$TARGET_FOLDER/static/css/src
if [ -d $CSS_SRC ]; then
    echo "[INFO] Building CSS assets..."
    bun build:css
fi

JS_SRC=$TARGET_FOLDER/static/js/src
if [ -d $JS_SRC ]; then
    echo "[INFO] Building JS assets..."
    bun build:js
fi

echo "[INFO] Generating styleguide using KSS..."
bun kss

# copy "styleguide" folder
echo "[INFO] Copying styleguide folder..."
cp -r styleguide $TARGET_FOLDER/

# copy "static" folder
echo "[INFO] Copying static folder..."
cp -r static $TARGET_FOLDER/

# update "static" folder path (to work correctly in github pages)
echo "[INFO] Replacing /static/ with /keyframes-styleguide/static/ ..."
sed -i'' -e 's|url("/static/|url("/keyframes-styleguide/static/|g' $TARGET_FOLDER/static/css/dist/main.css

# remove source files
if [ -d $CSS_SRC ]; then
    echo "[INFO] Clearing CSS source files..."
    rm -r $CSS_SRC
fi

if [ -d $JS_SRC ]; then
    echo "[INFO] Clearing JS source files..."
    rm -r $JS_SRC
fi

echo "Done."
