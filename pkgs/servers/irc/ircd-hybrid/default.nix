{ lib, stdenv, fetchurl, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "ircd-hybrid";
  version = "8.2.42";

  src = fetchurl {
    url = "mirror://sourceforge/ircd-hybrid/ircd-hybrid-${version}.tgz";
    sha256 = "sha256-aS0he/x+o3xOQ5H7hrCpJ4C8MusUT2liM0lyF1W4H2o=";
  };

  buildInputs = [ openssl zlib ];

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
