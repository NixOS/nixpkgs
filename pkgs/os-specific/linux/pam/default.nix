{ lib, stdenv, buildPackages, fetchurl
, fetchpatch
, flex, cracklib, db4, gettext, audit, libxcrypt
, nixosTests
, autoreconfHook269, pkg-config-unwrapped
}:

stdenv.mkDerivation rec {
  pname = "linux-pam";
  version = "1.5.3";

  src = fetchurl {
    url = "https://github.com/linux-pam/linux-pam/releases/download/v${version}/Linux-PAM-${version}.tar.xz";
    hash = "sha256-esS1D+7gBKn6iPHf0tL6c4qCiWdjBQzXc7PFSwqBgoM=";
  };

  patches = [
    ./suid-wrapper-path.patch
    # Pull support for localization on non-default --prefix:
    #   https://github.com/NixOS/nixpkgs/issues/249010
    #   https://github.com/linux-pam/linux-pam/pull/604
    (fetchpatch {
      name = "bind-locales.patch";
      url = "https://github.com/linux-pam/linux-pam/commit/77bd338125cde583ecdfb9fd69619bcd2baf15c2.patch";
      hash = "sha256-tlc9RcLZpEH315NFD4sdN9yOco8qhC6+bszl4OHm+AI=";
    })
  ]
  ++ lib.optional stdenv.hostPlatform.isMusl (fetchpatch {
      name = "missing-termio.patch";
      url = "https://github.com/linux-pam/linux-pam/commit/5374f677e4cae669eb9accf2449178b602e8a40a.patch";
      hash = "sha256-b6n8f16ETSNj5h+5/Yhn32XMfVO8xEnZRRhw+nuLP/8=";
    })
  ;

  # Case-insensitivity workaround for https://github.com/linux-pam/linux-pam/issues/569
  postPatch = if stdenv.buildPlatform.isDarwin && stdenv.buildPlatform != stdenv.hostPlatform then ''
    rm CHANGELOG
    touch ChangeLog
  '' else null;

  outputs = [ "out" "doc" "man" /* "modules" */ ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  # autoreconfHook269 is needed for `suid-wrapper-path.patch` and
  # `bind-locales.patch` above.
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
