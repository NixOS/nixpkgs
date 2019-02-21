{ writeScriptBin, stdenv, alsaPlugins }:
writeScriptBin "ap${if stdenv.hostPlatform.system == "i686-linux" then "32" else "64"}" ''
  #${stdenv.shell}
  ALSA_PLUGIN_DIRS=${alsaPlugins}/lib/alsa-lib "$@"
''
