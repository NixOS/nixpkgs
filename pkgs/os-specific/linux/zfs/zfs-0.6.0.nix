{ stdenv, fetchgit, kernel, linuxHeaders, spl, perl, zlib, libuuid }:

stdenv.mkDerivation {
  name = "zfs-0.6.0-rc4";
  src = fetchgit {
    url = git://github.com/behlendorf/zfs.git;
    rev = "3613204cd7e3ab1ae658";
    sha256 = "217ca162b1b0178dd2e3acc543d3c0cce3a7be7e884a9118ffa0a84d3cbc73f5";
  };

  patches = [ ./module_perm_prefix.patch ./mount_zfs_prefix.patch ./kerneldir_path.patch ];

  buildInputs = [ kernel linuxHeaders spl perl zlib libuuid];

  configureFlags = " --with-linux=${kernel}/lib/modules/${kernel.version}/build --with-linux-obj=${kernel}/lib/modules/${kernel.version}/build --with-spl=${spl}/libexec/spl-0.6.0/${kernel.version}";

  meta = {
    description = "Native ZFS for Linux";
    homepage = http://zfsonlinux.org/;
    license = "CDDL";
    platforms = stdenv.lib.platforms.linux;
  };
}
