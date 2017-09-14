{ stdenv, fetchurl, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "ircd-hybrid-8.2.21";

  src = fetchurl {
    url = "mirror://sourceforge/ircd-hybrid/${name}.tgz";
    sha256 = "19cgrgmmz1c72x4gxpd39f9ckm4j9cp1gpgvlkk73d3v13znfzy3";
  };

  buildInputs = [ openssl zlib ];

  configureFlags =
    "--with-nicklen=100 --with-topiclen=360 --enable-openssl=${openssl.dev}";

  postInstall = "echo postinstall; mkdir -p \${out}/ ; rm -rf \${out}/logs ; ln -s /home/ircd \${out}/logs;";

  meta = {
    description = "An IPv6-capable IRC server";
    platforms = stdenv.lib.platforms.unix;
    homepage = http://www.ircd-hybrid.org/;
  };
}
