{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="forktty";
    version="1.3";
    name="${baseName}-${version}";
    hash="0nd55zdqly6nl98k9lc7j751x86cw9hayx1qn0725f22r1x3j5zb";
    url="http://sunsite.unc.edu/pub/linux/utils/terminal/forktty-1.3.tgz";
    sha256="0nd55zdqly6nl98k9lc7j751x86cw9hayx1qn0725f22r1x3j5zb";
  };
  buildInputs = [
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  preBuild = ''
    sed -e s@/usr/bin/ginstall@install@g -i Makefile
  '';
  preInstall = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/share/man/man8"
  '';
  makeFlags = [ "prefix=$(out)" "manprefix=$(out)/share/" ];
  meta = {
    inherit (s) version;
    description = ''Tool to detach from controlling TTY and attach to another'';
    license = stdenv.lib.licenses.gpl2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
