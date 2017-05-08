{ stdenv, fetchpatch, fetchFromGitHub, autoreconfHook, libxslt, libxml2
, docbook_xml_dtd_412, docbook_xsl, gnome_doc_utils, flex, bison
, pam ? null, glibcCross ? null }:

let

  glibc =
    if stdenv ? cross
    then glibcCross
    else assert stdenv ? glibc; stdenv.glibc;

  dots_in_usernames = fetchpatch {
    url = http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/sys-apps/shadow/files/shadow-4.1.3-dots-in-usernames.patch;
    sha256 = "1fj3rg6x3jppm5jvi9y7fhd2djbi4nc5pgwisw00xlh4qapgz692";
  };

in

stdenv.mkDerivation rec {
  name = "shadow-${version}";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "shadow-maint";
    repo = "shadow";
    rev = "${version}";
    sha256 = "005qk3n86chc8mlg86qhrns2kpl52n5f3las3m5s6266xij3qwka";
  };

  buildInputs = stdenv.lib.optional (pam != null && stdenv.isLinux) pam;
  nativeBuildInputs = [autoreconfHook libxslt libxml2
    docbook_xml_dtd_412 docbook_xsl gnome_doc_utils flex bison
    ];

  patches =
    [ ./keep-path.patch
      dots_in_usernames
      (fetchpatch {
        url = https://github.com/shadow-maint/shadow/commit/507f96cdeb54079fb636c7ce21e371f7a16a520e.patch;
        sha256 = "0q20s0kil0n0wlj14fg646nhym4qn9sn34g8c78nk7fpknwpjmiw";
      })
    ];

  outputs = [ "out" "su" "man" ];

  enableParallelBuilding = true;

  # Assume System V `setpgrp (void)', which is the default on GNU variants
  # (`AC_FUNC_SETPGRP' is not cross-compilation capable.)
  preConfigure = ''
    export ac_cv_func_setpgrp_void=yes
    export shadow_cv_logdir=/var/log
    (
    head -n -1 "${docbook_xml_dtd_412}/xml/dtd/docbook/catalog.xml"
    tail -n +3 "${docbook_xsl}/share/xml/docbook-xsl/catalog.xml"
    ) > xmlcatalog
    configureFlags="$configureFlags --with-xml-catalog=$PWD/xmlcatalog ";
  '';

  configureFlags = " --enable-man ";

  preBuild = assert glibc != null;
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

  meta = {
    homepage = http://pkg-shadow.alioth.debian.org/;
    description = "Suite containing authentication-related tools such as passwd and su";
    platforms = stdenv.lib.platforms.linux;
  };

  passthru = {
    shellPath = "/bin/nologin";
  };
}
