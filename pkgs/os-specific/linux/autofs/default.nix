{ stdenv, lib, fetchurl, flex, bison, linuxHeaders, libtirpc, utillinux, nfs-utils, e2fsprogs
, libxml2, kerberos, kmod, openldap, sssd, cyrus_sasl, openssl }:

let
  version = "5.1.3";
  name = "autofs-${version}";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://kernel/linux/daemons/autofs/v5/${name}.tar.xz";
    sha256 = "1gxifa93104pxlmxrikhwciy5zdgk20m63siyhq1myym7vzfnvp9";
  };

  preConfigure = ''
    configureFlags="--enable-force-shutdown --enable-ignore-busy --with-path=$PATH"
    export sssldir="${sssd}/lib/sssd/modules"
    export HAVE_SSS_AUTOFS=1

    export MOUNT=${utillinux}/bin/mount
    export MOUNT_NFS=${nfs-utils}/bin/mount.nfs
    export UMOUNT=${utillinux}/bin/umount
    export MODPROBE=${utillinux}/bin/modprobe
    export E2FSCK=${e2fsprogs}/bin/fsck.ext2
    export E3FSCK=${e2fsprogs}/bin/fsck.ext3
    export E4FSCK=${e2fsprogs}/bin/fsck.ext4
  '';

  installPhase = ''
    make install SUBDIRS="lib daemon modules man" # all but samples
    #make install SUBDIRS="samples" # impure!
  '';

  buildInputs = [ linuxHeaders libtirpc libxml2 kerberos kmod openldap sssd
                  openssl cyrus_sasl ];

  nativeBuildInputs = [ flex bison ];

  meta = {
    description = "Kernel-based automounter";
    homepage = http://www.linux-consulting.com/Amd_AutoFS/autofs.html;
    license = stdenv.lib.licenses.gpl2;
    executables = [ "automount" ];
    platforms = stdenv.lib.platforms.linux;
  };
}
