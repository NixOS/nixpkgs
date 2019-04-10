{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation {
  name = "mstpd-0.0.5.20171113";

  src = fetchFromGitHub {
    owner = "mstpd";
    repo = "mstpd";
    rev = "2522c6eed201bce8dd81e1583f28748e9c552d0d";
    sha256 = "0ckk386inwcx3776hf15w78hpw4db2rgv4zgf0i3zcylr83hhsr2";
  };

  nativeBuildInputs = [ autoreconfHook ];

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "Multiple Spanning Tree Protocol daemon";
    homepage = https://sourceforge.net/projects/mstpd/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
