{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "unarj-${version}";
  version = "2.65";

  src = fetchurl {
    sha256 = "0r027z7a0azrd5k885xvwhrxicpd0ah57jzmaqlypxha2qjw7p6p";
    url = "http://pkgs.fedoraproject.org/repo/pkgs/unarj/${name}.tar.gz/c6fe45db1741f97155c7def322aa74aa/${name}.tar.gz";
  };

  preInstall = ''
    mkdir -p $out/bin
    sed -i -e s,/usr/local/bin,$out/bin, Makefile
  '';

  meta = {
    description = "Unarchiver of ARJ files";
    license = stdenv.lib.licenses.free;
  };
}
