{ stdenv, fetchurl, pkgconfig, SDL, libogg, libvorbis, zlib, unzip }:

let

  # Digital recordings of the music on an original Roland MT-32.  So
  # we don't need actual MIDI playback capability.
  audio = fetchurl {
    url = mirror://sourceforge/exult/exult_audio.zip;
    sha256 = "0s5wvgy9qja06v38g0qwzpaw76ff96vzd6gb1i3lb9k4hvx0xqbj";
  };

in

stdenv.mkDerivation rec {
  name = "exult-1.4.9rc1";

  src = fetchurl {
    url = "mirror://sourceforge/exult/${name}.tar.gz";
    sha256 = "0a03a2l3ji6h48n106d4w55l8v6lni1axniafnvvv5c5n3nz5bgd";
  };

  configureFlags = [ "--disable-tools" ];

  patches =
    [ # Arch Linux patch set.
      ./arch.patch
    ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ SDL libogg libvorbis zlib unzip ];

  enableParallelBuilding = true;

  makeFlags = [ "DESTDIR=$(out)" ];

  NIX_LDFLAGS = "-lX11";

  postInstall =
    ''
      mkdir -p $out/share/exult/music
      unzip -o -d $out/share/exult ${audio}
      chmod 644 $out/share/exult/*.flx
    ''; # */

  meta = {
    homepage = http://exult.sourceforge.net/;
    description = "A reimplementation of the Ultima VII game engine";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.unix;
    hydraPlatforms = stdenv.lib.platforms.linux; # darwin times out
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
