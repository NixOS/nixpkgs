{stdenv, fetchurl, lib, pkgconfig, alsaLib, pulseaudio, jackaudio}:
stdenv.mkDerivation {
  name = "alsa-plugins-1.0.23";

  src = fetchurl {
    url = ftp://ftp.alsa-project.org/pub/plugins/alsa-plugins-1.0.23.tar.bz2;
    sha256 = "10ri5dpmhk028r0qvajswh2xl40kjd600h7hykq03vrkmn8jf6sw";
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
    maintainers = [lib.maintainers.marcweber];
    platforms = lib.platforms.linux;
  };
}
