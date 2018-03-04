#!/bin/sh

# Create a variable equal to $HOME that will be used later in the ini creation
home=('$HOME')

if [ "$1" != "" ] && [ "$1" = "--newini" ]; then
  echo "Rebuilding the ini file at $HOME/.mame/mame.ini"
  echo "Modify this file for permanent changes to your @MAINBIN@"
  echo "options and paths before running @MAINBIN@ again."
  cd $HOME/.mame
  if [ -e mame.ini ]; then
    echo "Your old ini file has been renamed to mameini.bak"
    mv mame.ini mameini.bak
  fi
  @out@/usr/share/mame/@MAINBIN@ \
    -artpath "$home/.mame/artwork;artwork" \
    -ctrlrpath "$home/.mame/ctrlr;ctrlr" \
    -cheatpath "$home/.mame/cheat" \
    -crosshairpath "$home/.mame/crosshair" \
    -hashpath "$home/.mame/hash;hash" \
    -inipath $home/.mame/ini \
    -rompath $home/.mame/roms \
    -samplepath $home/.mame/samples \
    -cfg_directory $home/.mame/cfg \
    -comment_directory $home/.mame/comments \
    -diff_directory $home/.mame/diff \
    -input_directory $home/.mame/inp \
    -nvram_directory $home/.mame/nvram \
    -snapshot_directory $home/.mame/snap \
    -state_directory $home/.mame/sta \
    -video opengl \
    -createconfig
elif [ ! -e $HOME/.mame ]; then
  echo "Running @MAINBIN@ for the first time..."
  echo "Creating an ini file for @MAINBIN@ at $HOME/.mame/mame.ini"
  echo "Modify this file for permanent changes to your @MAINBIN@"
  echo "options and paths before running @MAINBIN@ again."
  mkdir $HOME/.mame
  mkdir $HOME/.mame/{artwork,cfg,cheat,comments,crosshair,ctrlr,diff,hash,ini,inp,nvram,samples,snap,sta,roms}
  cd $HOME/.mame
  @out@/usr/share/mame/@MAINBIN@ \
    -artpath "$home/.mame/artwork;artwork" \
    -ctrlrpath "$home/.mame/ctrlr;ctrlr" \
    -cheatpath "$home/.mame/cheat" \
    -crosshairpath "$home/.mame/crosshair" \
    -hashpath "$home/.mame/hash;hash" \
    -inipath $home/.mame/ini \
    -rompath $home/.mame/roms \
    -samplepath $home/.mame/samples \
    -cfg_directory $home/.mame/cfg \
    -comment_directory $home/.mame/comments \
    -diff_directory $home/.mame/diff \
    -input_directory $home/.mame/inp \
    -nvram_directory $home/.mame/nvram \
    -snapshot_directory $home/.mame/snap \
    -state_directory $home/.mame/sta \
    -video opengl \
    -createconfig
else
  cd @out@/usr/share/mame
  ./@MAINBIN@ "$@"
fi
