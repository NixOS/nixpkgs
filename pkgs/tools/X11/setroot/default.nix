{ stdenv, lib, fetchFromGitHub, libX11, imlib2
, enableXinerama ? true, libXinerama ? null
}:

assert enableXinerama -> libXinerama != null;

stdenv.mkDerivation rec {
  version = "2.0.1";
  name = "setroot-${version}";

  src = fetchFromGitHub {
    owner = "ttzhou";
    repo = "setroot";
    rev = "v${version}";
    sha256 = "01krjfc3xpp0wbqz9nvf1n34gkpd41gysn289sj1wcjxia4n4gsi";
  };

  buildInputs = [ libX11 imlib2 ]
    ++ stdenv.lib.optional enableXinerama libXinerama;

  buildFlags = "CC=cc " + (if enableXinerama then "xinerama=1" else "xinerama=0");

  installFlags = "DESTDIR=$(out) PREFIX=";

  meta = with stdenv.lib; {
    description = "Simple X background setter inspired by imlibsetroot and feh";
    homepage = https://github.com/ttzhou/setroot;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.vyp ];
    platforms = platforms.unix;
  };
}
