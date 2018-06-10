{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name    = "stunnel-${version}";
  version = "5.46";

  src = fetchurl {
    url    = "https://www.stunnel.org/downloads/${name}.tar.gz";
    sha256 = "1iw4gap9ysag8iww2ik029scmdllk7jdzcpnnbj7hgbl526b9akn";
    # please use the contents of "https://www.stunnel.org/downloads/${name}.tar.gz.sha256",
    # not the output of `nix-prefetch-url`
  };

  buildInputs = [ openssl ];
  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = {
    description = "Universal tls/ssl wrapper";
    homepage    = "http://www.stunnel.org/";
    license     = stdenv.lib.licenses.gpl2Plus;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
