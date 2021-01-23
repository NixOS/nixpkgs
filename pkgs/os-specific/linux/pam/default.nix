{ lib, stdenv, buildPackages, fetchurl, fetchpatch, flex, cracklib, db4
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "linux-pam";
  version = "1.5.1";

  src = fetchurl {
    url    = "https://github.com/linux-pam/linux-pam/releases/download/v${version}/Linux-PAM-${version}.tar.xz";
    sha256 = "sha256-IB1AcwsRNbGzzeoJ8sKKxjTXMYHM0Bcs7d7jZJxXkvw=";
  };

  patches = lib.optionals (stdenv.hostPlatform.libc == "musl") [
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/main/linux-pam/fix-compat.patch?id=05a62bda8ec255d7049a2bd4cf0fdc4b32bdb2cc";
      sha256 = "1h5yp5h2mqp1fcwiwwklyfpa69a3i03ya32pivs60fd7g5bqa7sf";
    })
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/main/linux-pam/libpam-fix-build-with-eglibc-2.16.patch?id=05a62bda8ec255d7049a2bd4cf0fdc4b32bdb2cc";
      sha256 = "1ib6shhvgzinjsc603k2x1lxh9dic6qq449fnk110gc359m23j81";
    })
  ];

  outputs = [ "out" "doc" "man" /* "modules" */ ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ flex ];

  buildInputs = [ cracklib db4 ];

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
