{ stdenv, fetchurl, ninja, python3 }:

stdenv.mkDerivation rec {
  name = "meson-0.26.0";

  src = fetchurl {
    url = "https://github.com/jpakkane/meson/archive/0.26.0.tar.gz";
    sha256 = "1hmfn1bkxnwsnlhw6x9ryfcm4zwsf2w7h51cll1xrxg1rq08fvck";
  };

  buildInputs = [ ninja python3 ];

  installPhase = ''
    python3 ./install_meson.py --prefix=$out --destdir="$pkgdir/"
  '';

  meta = {
    homepage = "http://mesonbuild.com";
    description = "SCons-like build system that use python as a front-end language and Ninja as a building backend";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.mbe ];
  };
}
