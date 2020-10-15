{ stdenv, fetchgit, autoconf, automake, pkgconfig, libtool, pam, libHX, libxml2, pcre, perl, openssl, cryptsetup, utillinux }:

stdenv.mkDerivation rec {
  name = "pam_mount-2.16-g40b6f2f";

  src = fetchgit {
    url    = "git://git.code.sf.net/p/pam-mount/pam-mount";
    rev    = "40b6f2f920922ff8bbfb45d1d5dfd5a554c16f62";
    sha256 = "01f6fdy3abld4465yqkshn1p7ja8ydglzzc48iqjw4q46hgz6rv1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake libtool pam libHX utillinux libxml2 pcre perl openssl cryptsetup ];

  patches = [ ./insert_utillinux_path_hooks.patch ];

  preConfigure = ''
    substituteInPlace src/mtcrypt.c --replace @@NIX_UTILLINUX@@ ${utillinux}/bin
    sh autogen.sh --prefix=$out
    '';

  makeFlags = [ "DESTDIR=$(out)" ];

  # Probably a hack, but using DESTDIR and PREFIX makes everything work!
  postInstall = ''
    mkdir -p $out
    cp -r $out/$out/* $out
    rm -r $out/nix
    '';

  meta = with stdenv.lib; {
    homepage = "http://pam-mount.sourceforge.net/";
    description = "PAM module to mount volumes for a user session";
    maintainers = [ maintainers.tstrobel ];
    license = with licenses; [ gpl2 gpl3 lgpl21 lgpl3 ];
    platforms = platforms.linux;
  };
}
