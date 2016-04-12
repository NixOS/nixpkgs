{ stdenv, fetchurl, devicemapper, openssl, libuuid, pkgconfig, popt
, enablePython ? false, python ? null
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  name = "cryptsetup-1.7.1";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/cryptsetup/v1.7/${name}.tar.xz";
    sha256 = "1v0zj4181ahckn5hn95kg3zbqw944raz769wdam5cjwqriiqmp3k";
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
