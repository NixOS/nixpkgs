{ stdenv, fetchurl, devicemapper, openssl, libuuid, pkgconfig, popt
, enablePython ? false, python2 ? null
}:

assert enablePython -> python2 != null;

stdenv.mkDerivation rec {
  name = "cryptsetup-1.7.5";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/cryptsetup/v1.7/${name}.tar.xz";
    sha256 = "1gail831j826lmpdx2gsc83lp3br6wfnwh3vqwxaa1nn1lfwsc1b";
  };

  configureFlags = [ "--enable-cryptsetup-reencrypt" "--with-crypto_backend=openssl" ]
                ++ stdenv.lib.optional enablePython "--enable-python";

  buildInputs = [ devicemapper openssl libuuid pkgconfig popt ]
             ++ stdenv.lib.optional enablePython python2;

  meta = {
    homepage = https://gitlab.com/cryptsetup/cryptsetup/;
    description = "LUKS for dm-crypt";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ viric chaoflow ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
