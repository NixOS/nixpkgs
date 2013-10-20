{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="ttysnoop";
    version="0.12d.k26";
    name="${baseName}-${version}";
    hash="0jb2zchaiqmmickj0la7wjw3sf9vy65qfhhs11yrzx4mmwkp0395";
    url="http://sysd.org/stas/files/active/0/ttysnoop-0.12d.k26.tar.gz";
    sha256="0jb2zchaiqmmickj0la7wjw3sf9vy65qfhhs11yrzx4mmwkp0395";
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
    sed -e "s@/sbin@$out/sbin@g" -i Makefile
    sed -e "s@/usr/man@$out/share/man@g" -i Makefile
    mkdir -p "$out/share/man/man8"
    mkdir -p "$out/sbin"
  '';
  postInstall = ''
    mkdir -p "$out/etc"
    cp snooptab.dist "$out/etc/snooptab"
  '';
  meta = {
    inherit (s) version;
    description = "A tool to clone input and output of another tty/pty to the current one";
    license = stdenv.lib.licenses.gpl ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
