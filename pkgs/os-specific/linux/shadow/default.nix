{ stdenv, fetchurl, pam ? null, glibcCross ? null }:

let

  glibc =
    if stdenv ? cross
    then glibcCross
    else assert stdenv ? glibc; stdenv.glibc;

  dots_in_usernames = fetchurl {
    url = http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/sys-apps/shadow/files/shadow-4.1.3-dots-in-usernames.patch;
    sha256 = "1fj3rg6x3jppm5jvi9y7fhd2djbi4nc5pgwisw00xlh4qapgz692";
  };

in

stdenv.mkDerivation rec {
  name = "shadow-4.2.1";

  src = fetchurl {
    url = "http://pkg-shadow.alioth.debian.org/releases/${name}.tar.xz";
    sha256 = "0h9x1zdbq0pqmygmc1x459jraiqw4gqz8849v268crk78z8r621v";
  };

  buildInputs = stdenv.lib.optional (pam != null && stdenv.isLinux) pam;

  patches = [ ./keep-path.patch dots_in_usernames ];

  outputs = [ "out" "su" ];

  # Assume System V `setpgrp (void)', which is the default on GNU variants
  # (`AC_FUNC_SETPGRP' is not cross-compilation capable.)
  preConfigure = ''
    export ac_cv_func_setpgrp_void=yes
    export shadow_cv_logdir=/var/log
  '';

  preBuild = assert glibc != null;
    ''
      substituteInPlace lib/nscd.c --replace /usr/sbin/nscd ${glibc.bin}/bin/nscd
    '';

  postInstall =
    ''
      # Don't install ‘groups’, since coreutils already provides it.
      rm $out/bin/groups $out/share/man/man1/groups.*

      # Move the su binary into the su package
      mkdir -p $su/bin
      mv $out/bin/su $su/bin
    '';

  meta = {
    homepage = http://pkg-shadow.alioth.debian.org/;
    description = "Suite containing authentication-related tools such as passwd and su";
  };
}
