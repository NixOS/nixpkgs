#!/bin/bash

runtime_home="${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja"
mkdir -p "$runtime_home"
cd "$runtime_home"

for src in folder random table; do
  if [[ ! -e $src ]] && [[ -e $BEATORAJA_HOME/$src ]]; then
    cp -Lr $BEATORAJA_HOME/$src .
    chmod -R u+w $src
  fi
done

for src in defaultsound font skin sound bgm; do
  if [[ ! -e $BEATORAJA_HOME/$src ]]; then
    continue
  fi
  if [[ -e $src ]] then
    if [[ -L $src ]]; then
      rm $src
    else
      mv $src $src.bak
    fi
  fi
  ln -s $BEATORAJA_HOME/$src $src
done

irPath=""
for ir in $BEATORAJA_HOME/ir/*; do
  irPath="$irPath:$ir"
done

export @ldEnv@

exec @java@ -Xms1g -Xmx4g \
  -Dsun.java2d.opengl=true \
  -Dawt.useSystemAAFontSettings=on \
  -Dswing.aatext=true \
  -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel \
  -Dfile.encoding=utf-8 \
  -cp "$BEATORAJA_HOME/beatoraja.jar$irPath" \
  bms.player.beatoraja.MainLoader
