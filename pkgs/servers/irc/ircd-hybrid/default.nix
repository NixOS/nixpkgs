{ lib, stdenv, fetchurl, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "ircd-hybrid-8.2.35";

  src = fetchurl {
    url = "mirror://sourceforge/ircd-hybrid/${name}.tgz";
    sha256 = "045wd3wa4i1hl7i4faksaj8l5r70ld55bggryaf1ml28ijwjwpca";
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
