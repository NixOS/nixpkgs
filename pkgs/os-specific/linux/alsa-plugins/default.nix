args: with args;
stdenv.mkDerivation {
  name = "alsa-plugins-1.0.19";

  src = fetchurl {
    url = ftp://ftp.alsa-project.org/pub/plugins/alsa-plugins-1.0.19.tar.bz2;
    sha256 = "000iqwlz93ykl0w19hw4qjh3gcw7f45ykmi91cw2m7dg4iy0igk7";
  };

  # TODO make backends such as jack, pulseaudio optional
  buildInputs = [pkgconfig alsaLib pulseaudio jackaudio];

  meta = { 
    description = "plugins for alsa eg conneckt jack, pluseaudio applications easily to the daemons using alsa devices";
    longDescription = "
      use it like this: export ALSA_PLUGIN_DIRS=$(nix-build -A alsaPlugins)/lib/alsa-lib
    ";
    homepage = http://alsa-project.org;
    license = "GPL2.1";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
