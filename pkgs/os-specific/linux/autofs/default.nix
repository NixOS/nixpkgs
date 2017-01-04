{ stdenv, lib, fetchurl, flex, bison, linuxHeaders, libtirpc, utillinux, nfs-utils, e2fsprogs
, libxml2, kerberos, kmod, openldap, sssd, cyrus_sasl, openssl }:

let
  version = "5.1.2";
  name = "autofs-${version}";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://kernel/linux/daemons/autofs/v5/${name}.tar.xz";
    sha256 = "031z64hmbzyllgvi72cw87755vnmafvsfwi0w21xksla10wxxdw8";
  };

  preConfigure = ''
    configureFlags="--enable-force-shutdown --enable-ignore-busy --with-path=$PATH --with-openldap=${openldap} --with-sasl=${cyrus_sasl}"
    export sssldir="${sssd}/lib/sssd/modules"
    export HAVE_SSS_AUTOFS=1

    export MOUNT=${lib.getBin utillinux}/bin/mount
    export MOUNT_NFS=${lib.getBin nfs-utils}/bin/mount.nfs
    export UMOUNT=${lib.getBin utillinux}/bin/umount
    export MODPROBE=${lib.getBin utillinux}/bin/modprobe
    export E2FSCK=${lib.getBin e2fsprogs}/bin/fsck.ext2
    export E3FSCK=${lib.getBin e2fsprogs}/bin/fsck.ext3
    export E4FSCK=${lib.getBin e2fsprogs}/bin/fsck.ext4
  '';

  installPhase = ''
    make install SUBDIRS="lib daemon modules man" # all but samples
    #make install SUBDIRS="samples" # impure!
  '';

  buildInputs = [ linuxHeaders libtirpc libxml2 kerberos kmod openldap sssd
                  openssl cyrus_sasl ];

  nativeBuildInputs = [ flex bison ];

  meta = {
    inherit version;
    description = "Kernel-based automounter";
    homepage = http://www.linux-consulting.com/Amd_AutoFS/autofs.html;
    license = stdenv.lib.licenses.gpl2;
    executables = [ "automount" ];
    platforms = stdenv.lib.platforms.linux;
  };
}
