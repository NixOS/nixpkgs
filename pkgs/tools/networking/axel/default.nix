{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "axel-1.0b";
  src = fetchurl {
    url = http://wilmer.gaast.net/downloads/axel-1.0b.tar.gz;
    sha256 = "1m3s3nviqi6n6iy7nzrdp31zn8pp6g923clsxf6m7yi1jfa1bifa";
  };

  meta = {
    description = "A console downloading program. Has some features for parallel connections for faster downloading.";
  };
}
