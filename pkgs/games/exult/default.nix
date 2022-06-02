{ lib, stdenv, fetchurl, pkg-config, SDL2, libogg, libvorbis, zlib, unzip }:

let

  # Digital recordings of the music on an original Roland MT-32.  So
  # we don't need actual MIDI playback capability.
  audio = fetchurl {
    url = "mirror://sourceforge/exult/exult_audio.zip";
    sha256 = "0s5wvgy9qja06v38g0qwzpaw76ff96vzd6gb1i3lb9k4hvx0xqbj";
  };

in

stdenv.mkDerivation rec {
  pname = "exult";
  version = "1.6";

  src = fetchurl {
    url = "mirror://sourceforge/exult/exult-${version}.tar.gz";
    sha256 = "1dm27qkxj30567zb70q4acddsizn0xyi3z87hg7lysxdkyv49s3s";
  };

  configureFlags = [ "--disable-tools" ];

  nativeBuildInputs = [ pkg-config unzip ];
  buildInputs = [ SDL2 libogg libvorbis zlib ];

  enableParallelBuilding = true;

  NIX_LDFLAGS = "-lX11";

  postInstall =
    ''
      mkdir -p $out/share/exult/music
      unzip -o -d $out/share/exult ${audio}
      chmod 644 $out/share/exult/*.flx
    ''; # */

  meta = {
    homepage = "http://exult.sourceforge.net/";
    description = "A reimplementation of the Ultima VII game engine";
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.unix;
    hydraPlatforms = lib.platforms.linux; # darwin times out
    license = lib.licenses.gpl2Plus;
  };
}
