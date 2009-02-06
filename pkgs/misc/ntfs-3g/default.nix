{stdenv, fetchurl, utillinux}:

stdenv.mkDerivation rec {
  pname = "ntfs-3g";
  version = "2009.1.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tgz";
    sha256 = "0e02ff891645658c1801ba7d665c0ff3a4231e5570b974a803ffc2974ef68e45";
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
