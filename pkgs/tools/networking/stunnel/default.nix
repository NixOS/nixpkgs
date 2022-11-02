{ lib, stdenv, fetchurl, openssl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "stunnel";
  version = "5.66";

  src = fetchurl {
    url    = "https://www.stunnel.org/downloads/${pname}-${version}.tar.gz";
    sha256 = "558178704d1aa5f6883aac6cc5d6bbf2a5714c8a0d2e91da0392468cee9f579c";
    # please use the contents of "https://www.stunnel.org/downloads/stunnel-${version}.tar.gz.sha256",
    # not the output of `nix-prefetch-url`
  };

  buildInputs = [ openssl ];
  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  postInstall = ''
    # remove legacy compatibility-wrapper that would require perl
    rm $out/bin/stunnel3
  '';

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  passthru.tests = {
    stunnel = nixosTests.stunnel;
  };

  meta = {
    description = "Universal tls/ssl wrapper";
    homepage    = "https://www.stunnel.org/";
    license     = lib.licenses.gpl2Plus;
    platforms   = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
