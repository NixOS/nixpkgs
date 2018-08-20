{ stdenv, fetchurl, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "ircd-hybrid-8.2.24";

  src = fetchurl {
    url = "mirror://sourceforge/ircd-hybrid/${name}.tgz";
    sha256 = "03nmzrhqfsxwry316nm80m9p285v65fz75ns7fg623hcy65jv97a";
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
    platforms = stdenv.lib.platforms.unix;
    homepage = http://www.ircd-hybrid.org/;
  };
}
