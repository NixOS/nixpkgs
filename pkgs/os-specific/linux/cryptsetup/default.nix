{ stdenv, fetchurl, devicemapper, json_c, openssl, libuuid, pkgconfig, popt
, enablePython ? false, python2 ? null }:

assert enablePython -> python2 != null;

stdenv.mkDerivation rec {
  name = "cryptsetup-2.0.3";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/cryptsetup/v2.0/${name}.tar.xz";
    sha256 = "1m01wl8njjraz69fsk97l3nqfc32nbpr1la5s1l4mzzmq42clv2d";
  };

  NIX_LDFLAGS = "-lgcc_s";

  configureFlags = [
    "--disable-kernel_crypto"
    "--enable-cryptsetup-reencrypt"
    "--with-crypto_backend=openssl"
  ] ++ stdenv.lib.optional enablePython "--enable-python";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ devicemapper json_c openssl libuuid popt ]
    ++ stdenv.lib.optional enablePython python2;

  meta = {
    homepage = https://gitlab.com/cryptsetup/cryptsetup/;
    description = "LUKS for dm-crypt";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ viric chaoflow ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
