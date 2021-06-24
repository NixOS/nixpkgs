{ lib, stdenv, fetchurl, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "ircd-hybrid-8.2.36";

  src = fetchurl {
    url = "mirror://sourceforge/ircd-hybrid/${name}.tgz";
    sha256 = "0sg4g0znl8ic8vklpy96z88gjksc165kl945a6fr1j4xc1bf8gcv";
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
