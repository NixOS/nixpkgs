{ stdenv, fetchurl, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "ircd-hybrid-8.2.22";

  src = fetchurl {
    url = "mirror://sourceforge/ircd-hybrid/${name}.tgz";
    sha256 = "1i5iv5hc8gbaw74mz18zdjzv3dsvyvr8adldj8p1726h4i2xzn6p";
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
