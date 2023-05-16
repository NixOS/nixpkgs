<<<<<<< HEAD
{
  fetchurl
, lib
, nixosTests
, openssl
, stdenv
, systemd
, systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stunnel";
  version = "5.70";
=======
{ lib, stdenv, fetchurl, openssl
, systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
, nixosTests
}:


stdenv.mkDerivation rec {
  pname = "stunnel";
  version = "5.69";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "doc" "man" ];

  src = fetchurl {
<<<<<<< HEAD
    url = "https://www.stunnel.org/archive/${lib.versions.major finalAttrs.version}.x/stunnel-${finalAttrs.version}.tar.gz";
    hash = "sha256-e7x7npqYjXYwEyXbTBEOw2Cpj/uKIhx6zL/5wKi64vM=";
=======
    url    = "https://www.stunnel.org/archive/${lib.versions.major version}.x/${pname}-${version}.tar.gz";
    sha256 = "sha256-H/fZ8wiEx1uYyKCk4VNPp5rcraIyJjXmeHM3tOOP24E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    homepage = "https://www.stunnel.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.thoughtpolice ];
    platforms = lib.platforms.unix;
  };
})
=======
    homepage    = "https://www.stunnel.org/";
    license     = lib.licenses.gpl2Plus;
    platforms   = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
