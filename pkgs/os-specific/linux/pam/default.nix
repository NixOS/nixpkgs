{ lib, stdenv, buildPackages, fetchurl, flex, cracklib, db4, gettext
, nixosTests
, withLibxcrypt ? false, libxcrypt
}:

stdenv.mkDerivation rec {
  pname = "linux-pam";
  version = "1.5.1";

  src = fetchurl {
    url    = "https://github.com/linux-pam/linux-pam/releases/download/v${version}/Linux-PAM-${version}.tar.xz";
    sha256 = "sha256-IB1AcwsRNbGzzeoJ8sKKxjTXMYHM0Bcs7d7jZJxXkvw=";
  };

  outputs = [ "out" "doc" "man" /* "modules" */ ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ flex ]
    ++ lib.optional stdenv.buildPlatform.isDarwin gettext;

  buildInputs = [ cracklib db4 ]
    ++ lib.optional withLibxcrypt libxcrypt;

  enableParallelBuilding = true;

  postInstall = ''
    mv -v $out/sbin/unix_chkpwd{,.orig}
    ln -sv /run/wrappers/bin/unix_chkpwd $out/sbin/unix_chkpwd
  ''; /*
    rm -rf $out/etc
    mkdir -p $modules/lib
    mv $out/lib/security $modules/lib/
  '';*/
  # don't move modules, because libpam needs to (be able to) find them,
  # which is done by dlopening $out/lib/security/pam_foo.so
  # $out/etc was also missed: pam_env(login:session): Unable to open config file

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
