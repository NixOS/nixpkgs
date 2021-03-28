{ lib, stdenv, fetchFromGitHub, libX11, imlib2
, enableXinerama ? true, libXinerama ? null
}:

assert enableXinerama -> libXinerama != null;

stdenv.mkDerivation rec {
  version = "2.0.2";
  pname = "setroot";

  src = fetchFromGitHub {
    owner = "ttzhou";
    repo = "setroot";
    rev = "v${version}";
    sha256 = "0w95828v0splk7bj5kfacp4pq6wxpyamvyjmahyvn5hc3ycq21mq";
  };

  buildInputs = [ libX11 imlib2 ]
    ++ lib.optional enableXinerama libXinerama;

  buildFlags = [ "CC=${stdenv.cc.targetPrefix}cc" (if enableXinerama then "xinerama=1" else "xinerama=0") ] ;

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = with lib; {
    description = "Simple X background setter inspired by imlibsetroot and feh";
    homepage = "https://github.com/ttzhou/setroot";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.vyp ];
    platforms = platforms.unix;
  };
}
