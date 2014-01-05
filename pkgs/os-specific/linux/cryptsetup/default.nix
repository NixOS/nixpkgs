{ stdenv, fetchurl, devicemapper, libgcrypt, libuuid, pkgconfig, popt
, enablePython ? false, python ? null
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  name = "cryptsetup-1.6.2";

  src = fetchurl {
    url = "http://cryptsetup.googlecode.com/files/${name}.tar.bz2";
    sha256 = "16hh7v8bsqy0i1wlaj03kwqjv3liffkvg06lk75lng9hk00kywhm";
  };

  configureFlags = [ "--enable-cryptsetup-reencrypt" ]
                ++ stdenv.lib.optional enablePython "--enable-python";

  buildInputs = [ devicemapper libgcrypt libuuid pkgconfig popt ]
             ++ stdenv.lib.optional enablePython python;

  meta = {
    homepage = http://code.google.com/p/cryptsetup/;
    description = "LUKS for dm-crypt";
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [ viric chaoflow ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
