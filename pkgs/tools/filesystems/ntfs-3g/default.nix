{stdenv, fetchurl, utillinux}:

stdenv.mkDerivation rec {
  pname = "ntfs-3g";
  version = "2009.4.4";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tgz";
    sha256 = "03qdbv0c6gfssmb2s0zzqhwp447n2hgr2qjvc0p527slj2z9xlxw";
  };

  preConfigure = ''
    substituteInPlace src/Makefile.in --replace /sbin '@sbindir@' 
    substituteInPlace libfuse-lite/mount_util.c \
      --replace /bin/mount ${utillinux}/bin/mount \
      --replace /bin/umount ${utillinux}/bin/umount
  '';

  configureFlags = "--disable-ldconfig --exec-prefix=\${prefix} --enable-mount-helper";

  meta = {
    homepage = http://www.ntfs-3g.org;
    description = "FUSE-base NTFS driver with full write support";
  };
}
