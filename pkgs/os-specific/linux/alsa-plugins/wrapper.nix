{ writeShellScriptBin, stdenv, alsaPlugins }:
writeShellScriptBin "ap${if stdenv.hostPlatform.system == "i686-linux" then "32" else "64"}" ''
  ALSA_PLUGIN_DIRS=${alsaPlugins}/lib/alsa-lib "$@"
''
