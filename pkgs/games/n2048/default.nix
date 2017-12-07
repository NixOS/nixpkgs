{stdenv, fetchurl, ncurses}:
let
  s = 
  rec {
    baseName = "n2048";
    version = "0.1";
    name = "${baseName}-${version}";
    url = "http://www.dettus.net/n2048/${baseName}_v${version}.tar.gz";
    sha256 = "184z2rr0rnj4p740qb4mzqr6kgd76ynb5gw9bj8hrfshcxdcg1kk";
  };
  buildInputs = [
    ncurses
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  makeFlags = [
    ''DESTDIR=$(out)''
  ];
  preInstall = ''
    mkdir -p "$out"/{share/man,bin}
  '';
  meta = {
    inherit (s) version;
    description = ''Console implementation of 2048 game'';
    license = stdenv.lib.licenses.bsd2;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://www.dettus.net/n2048/;
  };
}
