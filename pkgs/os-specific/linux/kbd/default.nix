{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation rec {
  name = "kbd-1.15";

  src = fetchurl {
    url = "ftp://ftp.altlinux.org/pub/people/legion/kbd/${name}.tar.gz";
    sha256 = "1h2klv4sxf0j08fzlpki2zf7f4k7m0j1d0ca01a1bsd8yza0l39d";
  };

  buildInputs = [bison flex];

  makeFlags = "setowner= ";
}
