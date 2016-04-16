{ stdenv, fetchurl, openssl, zlib }:

stdenv.mkDerivation {
  name = "ircd-hybrid-8.2.2";

  src = fetchurl {
    url = mirror://sourceforge/ircd-hybrid/ircd-hybrid-8.2.2.tgz;
    sha256 = "0k9w2mxgi03cpnmagshcr5v6qjgnmyidf966b50dd6yn1fgqcibm";
  };

  buildInputs = [ openssl zlib ];

  configureFlags =
    "--with-nicklen=100 --with-topiclen=360 --enable-openssl=${openssl.dev}";

  postInstall = "echo postinstall; mkdir -p \${out}/ ; rm -rf \${out}/logs ; ln -s /home/ircd \${out}/logs;";

  meta = {
    description = "An IPv6-capable IRC server";
  };
}
