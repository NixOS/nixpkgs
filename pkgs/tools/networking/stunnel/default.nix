{ lib, stdenv, fetchurl, openssl
, systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
, nixosTests
}:


stdenv.mkDerivation rec {
  pname = "stunnel";
  version = "5.69";

  outputs = [ "out" "doc" "man" ];

  src = fetchurl {
    url    = "https://www.stunnel.org/archive/${lib.versions.major version}.x/${pname}-${version}.tar.gz";
    sha256 = "sha256-H/fZ8wiEx1uYyKCk4VNPp5rcraIyJjXmeHM3tOOP24E=";
    # please use the contents of "https://www.stunnel.org/downloads/stunnel-${version}.tar.gz.sha256",
    # not the output of `nix-prefetch-url`
  };

  enableParallelBuilding = true;

  buildInputs = [
    openssl
  ] ++ lib.optionals systemdSupport [
    systemd
  ];

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    (lib.enableFeature systemdSupport "systemd")
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
