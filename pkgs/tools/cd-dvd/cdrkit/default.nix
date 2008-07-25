{stdenv, fetchurl, cmake, libcap, zlib, bzip2}:

stdenv.mkDerivation {
  name = "cdrkit-1.1.8";

  src = fetchurl {
    url = http://cdrkit.org/releases/cdrkit-1.1.8.tar.gz;
    sha256 = "0dzj89swc5h9jr6rr9y6cq6742gc1sdfaivz8r26yfmv5ajx104x";
  };

  buildInputs = [cmake libcap zlib bzip2];

  makeFlags = "PREFIX=\$(out)";

  meta = {
    description = "Portable command-line CD/DVD recorder software, mostly compatible with cdrtools";
    homepage = http://cdrkit.org/;
    license = "GPL2";
  };
}
