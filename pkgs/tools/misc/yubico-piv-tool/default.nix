{ stdenv, fetchurl, pkgconfig, openssl, pcsclite, check }:

stdenv.mkDerivation rec {
  name = "yubico-piv-tool-1.7.0";

  src = fetchurl {
    url = "https://developers.yubico.com/yubico-piv-tool/Releases/${name}.tar.gz";
    sha256 = "0zzxh8p9p097zkh9b3prbnigxsc2wy1pj1r8f5ikli9i81z54a5l";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl pcsclite check ];

  configureFlags = [ "--with-backend=pcsc" ];

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/yubico-piv-tool/;
    description = ''
      Used for interacting with the Privilege and Identification Card (PIV)
      application on a YubiKey
    '';
    longDescription = ''
      The Yubico PIV tool is used for interacting with the Privilege and
      Identification Card (PIV) application on a YubiKey.
      With it you may generate keys on the device, importing keys and
      certificates, and create certificate requests, and other operations.
      A shared library and a command-line tool is included.
    '';
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
