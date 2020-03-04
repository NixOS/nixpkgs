{ stdenv, fetchurl, autoconf, automake, pkgconfig, libtool, pam, libHX, libxml2, pcre, perl, openssl, cryptsetup, utillinux }:

stdenv.mkDerivation rec {
  name = "pam_mount-2.16";

  src = fetchurl {
    url = "mirror://sourceforge/pam-mount/pam_mount/2.16/${name}.tar.xz";
    sha256 = "1rvi4irb7ylsbhvx1cr6islm2xxw1a4b19q6z4a9864ndkm0f0mf";
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
    homepage = http://pam-mount.sourceforge.net/;
    description = "PAM module to mount volumes for a user session";
    maintainers = [ maintainers.tstrobel ];
    license = with licenses; [ gpl2 gpl3 lgpl21 lgpl3 ];
    platforms = platforms.linux;
  };
}
