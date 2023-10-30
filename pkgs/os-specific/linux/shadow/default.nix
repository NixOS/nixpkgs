{ lib, stdenv, fetchFromGitHub
, runtimeShell, nixosTests
, autoreconfHook, bison, flex
, docbook_xml_dtd_45, docbook_xsl
, itstool, libbsd, libxml2, libxslt
, libxcrypt, pkg-config
, glibcCross ? null
, pam ? null
, withTcb ? lib.meta.availableOn stdenv.hostPlatform tcb, tcb
}:
let
  glibc =
    if stdenv.hostPlatform != stdenv.buildPlatform then glibcCross
    else assert stdenv.hostPlatform.libc == "glibc"; stdenv.cc.libc;

in

stdenv.mkDerivation rec {
  pname = "shadow";
  version = "4.14.2";

  src = fetchFromGitHub {
    owner = "shadow-maint";
    repo = pname;
    rev = version;
    hash = "sha256-8sFXxP4MPFzKfBHzlKlsibj0lVQKJbC/Z7pWCy3WEuc=";
  };

  outputs = [ "out" "su" "dev" "man" ];

  RUNTIME_SHELL = runtimeShell;

  nativeBuildInputs = [
    autoreconfHook bison flex
    docbook_xml_dtd_45 docbook_xsl
    itstool libxml2 libxslt
    pkg-config
  ];

  buildInputs = [ libbsd libxcrypt ]
    ++ lib.optional (pam != null && stdenv.isLinux) pam
    ++ lib.optional withTcb tcb;

  patches = [
    ./keep-path.patch
    # Obtain XML resources from XML catalog (patch adapted from gtk-doc)
    ./respect-xml-catalog-files-var.patch
    ./runtime-shell.patch
    ./fix-install-with-tcb.patch
  ];

  # The nix daemon often forbids even creating set[ug]id files.
  postPatch = ''
    sed 's/^\(s[ug]idperms\) = [0-9]755/\1 = 0755/' -i src/Makefile.am
  '';

  # Assume System V `setpgrp (void)', which is the default on GNU variants
  # (`AC_FUNC_SETPGRP' is not cross-compilation capable.)
  preConfigure = ''
    export ac_cv_func_setpgrp_void=yes
    export shadow_cv_logdir=/var/log
  '';

  configureFlags = [
    "--enable-man"
    "--with-group-name-max-length=32"
    "--with-bcrypt"
    "--with-yescrypt"
  ] ++ lib.optional (stdenv.hostPlatform.libc != "glibc") "--disable-nscd"
    ++ lib.optional withTcb "--with-tcb";

  preBuild = lib.optionalString (stdenv.hostPlatform.libc == "glibc") ''
    substituteInPlace lib/nscd.c --replace /usr/sbin/nscd ${glibc.bin}/bin/nscd
  '';

  postInstall = ''
    # Don't install ‘groups’, since coreutils already provides it.
    rm $out/bin/groups
    rm $man/share/man/man1/groups.*

    # Move the su binary into the su package
    mkdir -p $su/bin
    mv $out/bin/su $su/bin
  '';

  enableParallelBuilding = true;

  disallowedReferences = lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) stdenv.shellPackage;

  meta = with lib; {
    homepage = "https://github.com/shadow-maint";
    description = "Suite containing authentication-related tools such as passwd and su";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };

  passthru = {
    shellPath = "/bin/nologin";
    tests = { inherit (nixosTests) shadow; };
  };
}
