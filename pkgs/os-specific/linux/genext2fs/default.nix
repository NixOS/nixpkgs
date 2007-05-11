{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "e2fsprogs-1.39";
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/genext2fs/genext2fs-1.4.1.tar.gz;
    sha256 = "1z7czvsf3ircvz2cw1cf53yifsq29ljxmj15hbgc79l6gbxbnka0";
  };
}
