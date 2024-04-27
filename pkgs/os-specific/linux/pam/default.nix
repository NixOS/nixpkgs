{ lib, stdenv, buildPackages, fetchurl, fetchpatch
, flex, cracklib, db4, gettext, audit, libxcrypt
, nixosTests
, autoreconfHook269, pkg-config-unwrapped
}:

stdenv.mkDerivation rec {
  pname = "linux-pam";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/linux-pam/linux-pam/releases/download/v${version}/Linux-PAM-${version}.tar.xz";
    hash = "sha256-//SjTlu+534ujxmS8nYx4jKby/igVj3etcM4m04xaa0=";
  };

  patches = [
    ./suid-wrapper-path.patch

    # Backport fix for missing include breaking musl builds.
    (fetchpatch {
      name = "pam_namespace-stdint.h.patch";
      url = "https://github.com/linux-pam/linux-pam/commit/cc9d40b7cdbd3e15ccaa324a0dda1680ef9dea13.patch";
      hash = "sha256-tCnH2yPO4dBbJOZA0fP2gm1EavHRMEJyfzB5Vy7YjAA=";
    })

    # Resotre handling of empty passwords:
    #   https://github.com/linux-pam/linux-pam/pull/784
    # TODO: drop upstreamed patch on 1.6.1 update.
    (fetchpatch {
      name = "revert-unconditional-helper.patch";
      url = "https://github.com/linux-pam/linux-pam/commit/8d0c575336ad301cd14e16ad2fdec6fe621764b8.patch";
      hash = "sha256-z9KfMxxqXQVnmNaixaVjLnQqaGsH8MBHhHbiP/8fvhE=";
    })
  ];

  # Case-insensitivity workaround for https://github.com/linux-pam/linux-pam/issues/569
  postPatch = if stdenv.buildPlatform.isDarwin && stdenv.buildPlatform != stdenv.hostPlatform then ''
    rm CHANGELOG
    touch ChangeLog
  '' else null;

  outputs = [ "out" "doc" "man" /* "modules" */ ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  # autoreconfHook269 is needed for `suid-wrapper-path.patch` above.
  # pkg-config-unwrapped is needed for `AC_CHECK_LIB` and `AC_SEARCH_LIBS`
  nativeBuildInputs = [ flex autoreconfHook269 pkg-config-unwrapped ]
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
    # The module is deprecated. We re-enable it explicitly until NixOS
    # module stops using it.
    "--enable-lastlog"
  ];

  installFlags = [
    "SCONFIGDIR=${placeholder "out"}/etc/security"
  ];

  doCheck = false; # fails

  passthru.tests = {
    inherit (nixosTests) pam-oath-login pam-u2f shadow sssd-ldap;
  };

  meta = with lib; {
    homepage = "http://www.linux-pam.org/";
    description = "Pluggable Authentication Modules, a flexible mechanism for authenticating user";
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
