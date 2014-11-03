{ stdenv, fetchurl, pkgconfig, libjpeg, libpng12, xlibs, libX11, mesa, libdrm, python27 }:
stdenv.mkDerivation rec {
  name = "glmark2-${version}";
  version = "2014.03";

  src = fetchurl {
    url = "https://launchpad.net/glmark2/trunk/${version}/+download/${name}.tar.gz";
    sha256 = "1dgn7ln115ivk13d1yagpj06lgllpv2jrr41kcnhdkhqz6m43vdx";
  };

  buildInputs = [
    pkgconfig libjpeg libpng12 xlibs.libxcb libX11 mesa libdrm python27
  ];

  buildPhase = ''
    python ./waf configure --prefix=$out --with-flavors x11-gl,x11-glesv2
    python2 ./waf
  '';

  installPhase = ''
    python2 ./waf install --destdir="$pkgdir/"
  '';

  meta = with stdenv.lib; {
    description = "OpenGL (ES) 2.0 benchmark";
    homepage = https://launchpad.net/glmark2;
    license = licenses.gpl3Plus;
    longDescription = ''
      glmark2 is a benchmark for OpenGL (ES) 2.0. It uses only the subset of
      the OpenGL 2.0 API that is compatible with OpenGL ES 2.0.
    '';
    platforms = platforms.linux;
    maintainers = [ maintainers.wmertens ];
  };
}

