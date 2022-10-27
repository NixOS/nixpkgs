{ lib, stdenv, fetchurl, fetchpatch, openssl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "stunnel";
  version = "5.65";

  src = fetchurl {
    url    = "https://www.stunnel.org/downloads/${pname}-${version}.tar.gz";
    sha256 = "60c500063bd1feff2877f5726e38278c086f96c178f03f09d264a2012d6bf7fc";
    # please use the contents of "https://www.stunnel.org/downloads/stunnel-${version}.tar.gz.sha256",
    # not the output of `nix-prefetch-url`
  };
  patches = [
    # Fixes compilation on darwin, patch is from
    # https://github.com/mtrojnar/stunnel/pull/15.
    (fetchpatch {
        name = "stunnel_darwin_environ.patch";
        url = "https://github.com/mtrojnar/stunnel/commit/d41932f6d55f639cc921007c2e180a55ef88bf00.patch";
        sha256 = "sha256-d2K/BHE6GxvDCBIbttCHEVwH9SCu0jggNvhVHkC/qto=";
      })
  ];

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
