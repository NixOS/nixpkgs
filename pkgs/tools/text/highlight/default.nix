{ stdenv, fetchurl, getopt, lua, boost }:
        
stdenv.mkDerivation rec {
  name = "highlight-3.5";

  src = fetchurl {
    url = "http://www.andre-simon.de/zip/${name}.tar.bz2";
    sha256 = "0jpidd2fwn5mbrgzjmh53qvfmqqp6g0mah7i5zsf9bd71ga1lp28";
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
