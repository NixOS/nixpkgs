{ lib, stdenv, buildPackages, fetchurl, flex, cracklib, db4, gettext, audit, libxcrypt
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "linux-pam";
  version = "1.5.2";

  src = fetchurl {
    url    = "https://github.com/linux-pam/linux-pam/releases/download/v${version}/Linux-PAM-${version}.tar.xz";
    sha256 = "sha256-5OxxMakdpEUSV0Jo9JPG2MoQXIcJFpG46bVspoXU+U0=";
  };

  patches = [ ./suid-wrapper-path.patch ];

  outputs = [ "out" "doc" "man" /* "modules" */ ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ flex ]
    ++ lib.optional stdenv.buildPlatform.isDarwin gettext;

  buildInputs = [ cracklib db4 libxcrypt ]
    ++ lib.optional stdenv.buildPlatform.isLinux audit;

  enableParallelBuilding = true;

  preConfigure = lib.optionalString (stdenv.hostPlatform.libc == "musl") ''
      # export ac_cv_search_crypt=no
      # (taken from Alpine linux, apparently insecure but also doesn't build O:))
      # disable insecure modules
      # sed -e 's/pam_rhosts//g' -i modules/Makefile.am
      sed -e 's/pam_rhosts//g' -i modules/Makefile.in
  '';

  configureFlags = [
    "--includedir=${placeholder "out"}/include/security"
    "--enable-sconfigdir=/etc/security"
  ];

  installFlags = [
    "SCONFIGDIR=${placeholder "out"}/etc/security"
  ];

  doCheck = false; # fails

  passthru.tests = {
    inherit (nixosTests) pam-oath-login pam-u2f shadow;
  };

  meta = with lib; {
    homepage = "http://www.linux-pam.org/";
    description = "Pluggable Authentication Modules, a flexible mechanism for authenticating user";
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
