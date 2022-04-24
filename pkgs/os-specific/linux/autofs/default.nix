{ lib, stdenv, fetchurl, flex, bison, linuxHeaders, libtirpc, mount, umount, nfs-utils, e2fsprogs
, libxml2, libkrb5, kmod, openldap, sssd, cyrus_sasl, openssl, rpcsvc-proto
, fetchpatch
}:

stdenv.mkDerivation rec {
  version = "5.1.6";
  pname = "autofs";

  src = fetchurl {
    url = "mirror://kernel/linux/daemons/autofs/v5/autofs-${version}.tar.xz";
    sha256 = "1vya21mb4izj3khcr3flibv7xc15vvx2v0rjfk5yd31qnzcy7pnx";
  };

  patches = [
    # glibc 2.34 compat
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/autofs/raw/cc745af5e42396d540d5b3b92fae486e232bf6bd/f/autofs-5.1.7-use-default-stack-size-for-threads.patch";
      sha256 = "sha256-6ETDFbW7EhHR03xFWF+6OJBgn9NX3WW3bGhTNGodaOc=";
      excludes = [ "CHANGELOG" ];
    })
  ];

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

  # configure script is not finding the right path
  NIX_CFLAGS_COMPILE = [ "-I${libtirpc.dev}/include/tirpc" ];

  installPhase = ''
    make install SUBDIRS="lib daemon modules man" # all but samples
    #make install SUBDIRS="samples" # impure!
  '';

  buildInputs = [ linuxHeaders libtirpc libxml2 libkrb5 kmod openldap sssd
                  openssl cyrus_sasl rpcsvc-proto ];

  nativeBuildInputs = [ flex bison ];

  meta = {
    description = "Kernel-based automounter";
    homepage = "https://www.kernel.org/pub/linux/daemons/autofs/";
    license = lib.licenses.gpl2Plus;
    executables = [ "automount" ];
    platforms = lib.platforms.linux;
  };
}
