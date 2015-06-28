{ stdenv, fetchurl, devicemapper, openssl, libuuid, pkgconfig, popt
, enablePython ? false, python ? null
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  name = "cryptsetup-1.6.7";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/cryptsetup/v1.6/${name}.tar.xz";
    sha256 = "0878vwblazms1dac2ds7vyz8pgi1aac8870ccnl2s0v2sv428g62";
  };

  configureFlags = [ "--enable-cryptsetup-reencrypt" "--with-crypto_backend=openssl" ]
                ++ stdenv.lib.optional enablePython "--enable-python";

  buildInputs = [ devicemapper openssl libuuid pkgconfig popt ]
             ++ stdenv.lib.optional enablePython python;

  meta = {
    homepage = http://code.google.com/p/cryptsetup/;
    description = "LUKS for dm-crypt";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ viric chaoflow ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
