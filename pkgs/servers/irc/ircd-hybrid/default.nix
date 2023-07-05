{ lib, stdenv, fetchurl, openssl, zlib, libxcrypt }:

stdenv.mkDerivation rec {
  pname = "ircd-hybrid";
  version = "8.2.43";

  src = fetchurl {
    url = "mirror://sourceforge/ircd-hybrid/ircd-hybrid-${version}.tgz";
    sha256 = "sha256-vQNzx4DjCMGm9piQFf8o4cIpme92S3toY2tihXPCUe8=";
  };

  buildInputs = [ openssl zlib libxcrypt ];

  configureFlags = [
    "--with-nicklen=100"
    "--with-topiclen=360"
    "--enable-openssl=${openssl.dev}"
  ];

  postInstall = "echo postinstall; mkdir -p \${out}/ ; rm -rf \${out}/logs ; ln -s /home/ircd \${out}/logs;";

  meta = {
    description = "An IPv6-capable IRC server";
    platforms = lib.platforms.unix;
    homepage = "https://www.ircd-hybrid.org/";
  };
}
