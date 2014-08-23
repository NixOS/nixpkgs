{ stdenv, fetchurl, getopt, lua, boost }:
        
stdenv.mkDerivation rec {
  name = "highlight-3.9";

  src = fetchurl {
    url = "http://www.andre-simon.de/zip/${name}.tar.bz2";
    sha256 = "1vysj34zz8gk5yhlzm7g6lbphb8y6zfbd9smfgsgwkyawfargrja";
  };

  buildInputs = [ getopt lua boost ];

  makeFlags = [
    "PREFIX=$(out)"
    "conf_dir=$(out)/etc/highlight/"
  ];

  meta = {
    description = "Source code highlighting tool";
  };
}
