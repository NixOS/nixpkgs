{ stdenv, lib, fetchFromGitHub, libX11, imlib2
, enableXinerama ? true, libXinerama ? null
}:

assert enableXinerama -> libXinerama != null;

stdenv.mkDerivation rec {
  version = "1.4.4";
  name = "setroot-${version}";

  src = fetchFromGitHub {
    owner = "ttzhou";
    repo = "setroot";
    rev = "v${version}";
    sha256 = "0vphma0as8pnqrakdw6gaiiz7xawb4y72sc9dna755kkclgbyl8m";
  };

  buildInputs = [ libX11 imlib2 ]
    ++ stdenv.lib.optional enableXinerama libXinerama;

  buildFlags = "CC=cc " + (if enableXinerama then "xinerama=1" else "xinerama=0");

  installFlags = "DESTDIR=$(out) PREFIX=";

  meta = with stdenv.lib; {
    description = "Simple X background setter inspired by imlibsetroot and feh";
    homepage = https://github.com/ttzhou/setroot;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
