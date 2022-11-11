{ lib, stdenv, fetchurl, openssl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "stunnel";
  version = "5.67";

  src = fetchurl {
    url    = "https://www.stunnel.org/archive/${lib.versions.major version}.x/${pname}-${version}.tar.gz";
    sha256 = "3086939ee6407516c59b0ba3fbf555338f9d52f459bcab6337c0f00e91ea8456";
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
