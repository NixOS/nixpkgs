{stdenv, fetchurl, x11}:

stdenv.mkDerivation {
  name = "xsel-0.9.6";
  src = fetchurl {
    url = http://www.vergenet.net/~conrad/software/xsel/download/xsel-0.9.6.tar.gz;
    md5 = "cec2fb09a4101b7f2beab8094234e2f4";
  };

  buildInputs = [x11];
}
