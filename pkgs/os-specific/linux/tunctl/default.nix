{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "tunctl-1.5";
  src = fetchurl {
    url = mirror://sourceforge/tunctl/tunctl-1.5.tar.gz;
    sha256 = "aa2a6c4cc6bfacb11e0d9f62334a6638a0d435475c61230116f00b6af8b14fff";
  };

  makeFlags = [ "tunctl" ];
  installPhase = ''
    mkdir -p $out/bin
    cp tunctl $out/bin
  '';

  meta = {
    homepage = http://tunctl.sourceforge.net/;
    description = "Utility to set up and maintain TUN/TAP network interfaces";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
