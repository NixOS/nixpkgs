{ lib, stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  pname = "stunnel";
  version = "5.62";

  src = fetchurl {
    url    = "https://www.stunnel.org/downloads/${pname}-${version}.tar.gz";
    sha256 = "sha256-nPW7lJAiqmbHNsEyZVTMon0GQWBaY3AnTtxJUetb0zk=";
    # please use the contents of "https://www.stunnel.org/downloads/${name}.tar.gz.sha256",
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

  meta = {
    description = "Universal tls/ssl wrapper";
    homepage    = "https://www.stunnel.org/";
    license     = lib.licenses.gpl2Plus;
    platforms   = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
