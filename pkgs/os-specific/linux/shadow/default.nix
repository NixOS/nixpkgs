{ stdenv, fetchpatch, fetchFromGitHub, autoreconfHook, libxslt, libxml2
, docbook_xml_dtd_45, docbook_xsl, itstool, flex, bison
, pam ? null, glibcCross ? null
}:

let

  glibc =
    if stdenv.hostPlatform != stdenv.buildPlatform
    then glibcCross
    else assert stdenv.hostPlatform.libc == "glibc"; stdenv.cc.libc;

  dots_in_usernames = fetchpatch {
    url = http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/sys-apps/shadow/files/shadow-4.1.3-dots-in-usernames.patch;
    sha256 = "1fj3rg6x3jppm5jvi9y7fhd2djbi4nc5pgwisw00xlh4qapgz692";
  };

in

stdenv.mkDerivation rec {
  pname = "shadow";
  version = "4.8";

  src = fetchFromGitHub {
    owner = "shadow-maint";
    repo = "shadow";
    rev = version;
    sha256 = "05a636dqxip09l5jjrrs30lvwq6xkhjrdgjbbj3bg6b6z7hc67qk";
  };

  buildInputs = stdenv.lib.optional (pam != null && stdenv.isLinux) pam;
  nativeBuildInputs = [autoreconfHook libxslt libxml2
    docbook_xml_dtd_45 docbook_xsl flex bison itstool
    ];

  patches =
    [ ./keep-path.patch
      # Obtain XML resources from XML catalog (patch adapted from gtk-doc)
      ./respect-xml-catalog-files-var.patch
      dots_in_usernames
    ];

  # The nix daemon often forbids even creating set[ug]id files.
  postPatch =
    ''sed 's/^\(s[ug]idperms\) = [0-9]755/\1 = 0755/' -i src/Makefile.am
    '';

  outputs = [ "out" "su" "man" ];

  enableParallelBuilding = true;

  # Assume System V `setpgrp (void)', which is the default on GNU variants
  # (`AC_FUNC_SETPGRP' is not cross-compilation capable.)
  preConfigure = ''
    export ac_cv_func_setpgrp_void=yes
    export shadow_cv_logdir=/var/log
  '';

  configureFlags = [
    "--enable-man"
    "--with-group-name-max-length=32"
  ] ++ stdenv.lib.optional (stdenv.hostPlatform.libc != "glibc") "--disable-nscd";

  preBuild = stdenv.lib.optionalString (stdenv.hostPlatform.libc == "glibc")
    ''
      substituteInPlace lib/nscd.c --replace /usr/sbin/nscd ${glibc.bin}/bin/nscd
    '';

  postInstall =
    ''
      # Don't install ‘groups’, since coreutils already provides it.
      rm $out/bin/groups
      rm $man/share/man/man1/groups.*

      # Move the su binary into the su package
      mkdir -p $su/bin
      mv $out/bin/su $su/bin
    '';

  meta = with stdenv.lib; {
    homepage = https://github.com/shadow-maint;
    description = "Suite containing authentication-related tools such as passwd and su";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };

  passthru = {
    shellPath = "/bin/nologin";
  };
}
