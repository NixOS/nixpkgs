{stdenv, fetchurl, x11}:

stdenv.mkDerivation {
  name = "xsel-0.9.6";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/xsel-0.9.6.tar.gz;
    md5 = "cec2fb09a4101b7f2beab8094234e2f4";
  };

  buildInputs = [x11];
}
