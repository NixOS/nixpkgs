{stdenv, fetchurl, utillinux}:

stdenv.mkDerivation rec {
  pname = "ntfs-3g";
  version = "1.5012";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tgz";
    sha256 = "e79102fdb5948f209d25432f8f5127965877fe47bed68b9270b23fc1d187735a";
  };

  preConfigure = ''
    substituteInPlace src/Makefile.in --replace /sbin '@sbindir@' 
    substituteInPlace libfuse-lite/mount_util.c \
      --replace /bin/mount ${utillinux}/bin/mount \
      --replace /bin/umount ${utillinux}/bin/umount
  '';

  configureFlags = "--enable-shared --disable-static --disable-ldconfig --exec-prefix=\${prefix} --enable-mount-helper";

  meta = {
    homepage = http://www.ntfs-3g.org;
    description = "FUSE-base NTFS driver with full write support";
  };
}
