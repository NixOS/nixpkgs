{ stdenv, fetchFromGitHub, writeText, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "cetch";
  version = "071796fab4850034f1f45e687021d7ff05d8302a";

  src = fetchFromGitHub {
    owner = "wooosh";
    repo = name;
    rev = version;
    sha256 = "1mzlprkyd6imn5lm7srw78zxd1wy9xdb7a2diwpdfx1gfif0iimi";
  };

  configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "A fast, highly customizable system info script written in C";
    homepage = https://github.com/trvv/cetch;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.wooosh ];
  };
}
