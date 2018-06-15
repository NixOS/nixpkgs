{ stdenv, fetchurl, devicemapper, json_c, openssl, libuuid, pkgconfig, popt
, enablePython ? false, python2 ? null }:

assert enablePython -> python2 != null;

stdenv.mkDerivation rec {
  name = "cryptsetup-2.0.2";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/cryptsetup/v2.0/${name}.tar.xz";
    sha256 = "15wyjfgcqjf0wy5gxnmjj8aah33csv5v6n1hv9c8sxdzygbhb0ag";
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
