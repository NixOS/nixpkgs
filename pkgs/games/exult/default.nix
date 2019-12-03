{ stdenv, fetchurl, fetchFromGitHub, pkgconfig, automake, autoconf, libtool, SDL, libogg, libvorbis, zlib, unzip }:

let

  # Digital recordings of the music on an original Roland MT-32.  So
  # we don't need actual MIDI playback capability.
  audio = fetchurl {
    url = mirror://sourceforge/exult/exult_audio.zip;
    sha256 = "0s5wvgy9qja06v38g0qwzpaw76ff96vzd6gb1i3lb9k4hvx0xqbj";
  };

in

stdenv.mkDerivation rec {
  name = "exult-1.5.0git";

  src = fetchFromGitHub {
    owner = "exult";
    repo = "exult";
    rev = "b727abfffc08a54e528bc1194d0de8562d18d74e";
    sha256 = "1nvxpsycn7r2yiqlyjq8rx9wy2ywc8lnqivh6jzdh9rxryq05j94";
  };

  preConfigure = "./autogen.sh";

  configureFlags = [ "--disable-tools" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ automake autoconf libtool SDL libogg libvorbis zlib unzip ];

  enableParallelBuilding = true;

  postInstall =
    ''
      mkdir -p $out/share/exult/music
      unzip -o -d $out/share/exult ${audio}
      chmod 644 $out/share/exult/*.flx
    '';

  meta = {
    homepage = http://exult.sourceforge.net/;
    description = "A reimplementation of the Ultima VII game engine";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.unix;
    hydraPlatforms = stdenv.lib.platforms.linux; # darwin times out
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
