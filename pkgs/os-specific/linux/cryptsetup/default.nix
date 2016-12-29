{ stdenv, fetchurl, devicemapper, openssl, libuuid, pkgconfig, popt
, enablePython ? false, python2 ? null
}:

assert enablePython -> python2 != null;

stdenv.mkDerivation rec {
  name = "cryptsetup-1.7.3";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/cryptsetup/v1.7/${name}.tar.xz";
    sha256 = "00nwd96m9yq4k3cayc04i5y7iakkzana35zxky6hpx2w8zl08axg";
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
