{ stdenv, fetchurl, openssl, zlib }:

stdenv.mkDerivation {
  name = "ircd-hybrid-7.2.3";

  src = fetchurl {
    url = mirror://sourceforge/ircd-hybrid/ircd-hybrid-7.2.3.tgz;
    sha256 = "0w28w10vx3j2s6h2p0qx2p08gafyad7ddxa4f8i94vmx193l7w37";
  };

  buildInputs = [ openssl zlib ];

  configureFlags =
    "--with-nicklen=100 --with-topiclen=360 --enable-openssl=${openssl}";

  postInstall = "echo postinstall; mkdir -p \${out}/ ; rm -rf \${out}/logs ; ln -s /home/ircd \${out}/logs;";

  meta = {
    description = "An IPv6-capable IRC server";
  };
}
