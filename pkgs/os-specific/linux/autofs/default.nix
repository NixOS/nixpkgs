{ stdenv, fetchurl, flex, bison, linuxHeaders, libtirpc, mount, umount, nfs-utils, e2fsprogs
, libxml2, kerberos, kmod, openldap, sssd, cyrus_sasl, openssl }:

let
  version = "5.1.6";
  name = "autofs-${version}";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://kernel/linux/daemons/autofs/v5/${name}.tar.xz";
    sha256 = "1vya21mb4izj3khcr3flibv7xc15vvx2v0rjfk5yd31qnzcy7pnx";
  };

  preConfigure = ''
    configureFlags="--enable-force-shutdown --enable-ignore-busy --with-path=$PATH"
    export sssldir="${sssd}/lib/sssd/modules"
    export HAVE_SSS_AUTOFS=1

    export MOUNT=${mount}/bin/mount
    export MOUNT_NFS=${nfs-utils}/bin/mount.nfs
    export UMOUNT=${umount}/bin/umount
    export MODPROBE=${kmod}/bin/modprobe
    export E2FSCK=${e2fsprogs}/bin/fsck.ext2
    export E3FSCK=${e2fsprogs}/bin/fsck.ext3
    export E4FSCK=${e2fsprogs}/bin/fsck.ext4

    unset STRIP # Makefile.rules defines a usable STRIP only without the env var.
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
    homepage = https://www.kernel.org/pub/linux/daemons/autofs/;
    license = stdenv.lib.licenses.gpl2Plus;
    executables = [ "automount" ];
    platforms = stdenv.lib.platforms.linux;
  };
}
