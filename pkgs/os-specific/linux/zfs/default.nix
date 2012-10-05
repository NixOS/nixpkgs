{ stdenv, fetchurl, kernel, spl, perl, zlib, libuuid, coreutils, utillinux }:

stdenv.mkDerivation {
  name = "zfs-0.6.0-rc11";
  src = fetchurl {
    url = http://github.com/downloads/zfsonlinux/zfs/zfs-0.6.0-rc11.tar.gz;
    sha256 = "0wx0srn2k31j9xdk3nvk7l847r0diyb7ph6hd006ax9l5p9zj0a7";
  };

  patches = [ ./module_perm_prefix.patch ./mount_zfs_prefix.patch ./kerneldir_path.patch ./no_absolute_paths_to_coreutils.patch ];

  buildInputs = [ kernel spl perl zlib libuuid coreutils ];

  NIX_CFLAGS_COMPILE = "-I${kernel}/lib/modules/${kernel.modDirVersion}/build/include/generated";

  preConfigure = ''
    substituteInPlace ./module/zfs/zfs_ctldir.c  --replace "umount -t zfs"   "${utillinux}/bin/umount -t zfs"
    substituteInPlace ./module/zfs/zfs_ctldir.c  --replace "mount -t zfs"    "${utillinux}/bin/mount -t zfs"
  '';

  configureFlags = ''
    --with-linux=${kernel}/lib/modules/${kernel.version}/build 
    --with-linux-obj=${kernel}/lib/modules/${kernel.version}/build 
    --with-spl=${spl}/libexec/spl/${kernel.version}
  '';

  meta = {
    description = "Native ZFS for Linux";
    homepage = http://zfsonlinux.org/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.cddl;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
