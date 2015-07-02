{ stdenv, fetchurl, autoconf, automake, pkgconfig, libtool, pam, libHX, utillinux, libxml2, pcre, perl, openssl, cryptsetup }:

stdenv.mkDerivation rec {
  name = "pam_mount-2.15";

  src = fetchurl {
    url = "mirror://sourceforge/pam-mount/pam_mount/2.15/${name}.tar.xz";
    sha256 = "091aq5zyc60wh21m1ryanjwknwxlaj9nvlswn5vjrmcdir5gnkm5";
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
