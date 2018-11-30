{ writeScriptBin, stdenv, alsaPlugins }:
writeScriptBin "ap${if stdenv.hostPlatform.system == "i686-linux" then "32" else "64"}" ''
  #/bin/sh
  ALSA_PLUGIN_DIRS=${alsaPlugins}/lib/alsa-lib "$@"
''
