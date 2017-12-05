{ stdenv, fetchurl, libX11 }:

stdenv.mkDerivation rec {
  version = "0.2";
  name = "sselp-${version}";
 
  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "08mqp00lrh1chdrbs18qr0xv63h866lkmfj87kfscwdm1vn9a3yd";
  };
 
  buildInputs = [ libX11 ];

  patchPhase = ''
    sed -i "s@/usr/local@$out@g" config.mk
    sed -i "s@/usr/X11R6/include@${libX11}/include@g" config.mk
    sed -i "s@/usr/X11R6/lib@${libX11}/lib@g" config.mk
  '';

  meta = {
    homepage = http://tools.suckless.org/sselp;
    description = "Prints the X selection to stdout, useful in scripts";
    license = stdenv.lib.licenses.mit;
    maintainers = [stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
