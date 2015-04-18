{ stdenv, fetchurl, autoconf, automake, pkgconfig, libtool, pam, libHX, utillinux, libxml2, pcre, perl, openssl, cryptsetup }:

stdenv.mkDerivation rec {
  name = "pam_mount-2.14";

  src = fetchurl {
    url = "mirror://sourceforge/pam-mount/pam_mount/2.14/${name}.tar.xz";
    sha256 = "1yfwg8i4n7af8yi3w3pkqzqz75wgjjlg5lslv1r5g1v88nrwnrkg";
  };

  buildInputs = [ autoconf automake pkgconfig libtool pam libHX utillinux libxml2 pcre perl openssl cryptsetup ];

  preConfigure = "sh autogen.sh --prefix=$out";

  makeFlags = "DESTDIR=$(out)";

  # Probably a hack, but using DESTDIR and PREFIX makes everything work!
  postInstall = ''
    cp -r $out/$out/* $out
    rm -r $out/nix
    '';

  meta = {
    homepage = http://pam-mount.sourceforge.net/;
    description = "PAM module to mount volumes for a user session";
    maintainers = [ stdenv.lib.maintainers.tstrobel ];
    platforms = stdenv.lib.platforms.linux;
  };
}
