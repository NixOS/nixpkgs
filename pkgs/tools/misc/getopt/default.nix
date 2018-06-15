{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "getopt-1.1.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://tarballs.nixos.org/getopt-1.1.4.tar.gz;
    sha256 = "1arvjfzw6p310zbgv629w5hkyslrj44imf3r3s2r4ry2jfcks221";
  };
  preBuild = ''
    export buildFlags=CC="$CC" # for darwin
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
