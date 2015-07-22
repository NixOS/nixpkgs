{ stdenv, fetchurl, pkgconfig, perl, utillinux, keyutils, nss, nspr, python, pam
, intltool, makeWrapper, coreutils, bash, gettext, cryptsetup, lvm2, rsync, which }:

stdenv.mkDerivation rec {
  name = "ecryptfs-${version}";
  version = "106";

  src = fetchurl {
    url = "http://launchpad.net/ecryptfs/trunk/${version}/+download/ecryptfs-utils_${version}.orig.tar.gz";
    sha256 = "1d5nlzcbl8ch639zi3lq6d14gkk4964j6dqhfs87i67867fhlghp";
  };

  #TODO: replace wrapperDir below with from <nixos> config.security.wrapperDir;
  postPatch = ''
    FILES="$(grep -r '/bin/sh' src/utils -l; find src -name \*.c)"
    for file in $FILES; do
      substituteInPlace "$file" \
        --replace /sbin/mount.ecryptfs_private /var/setuid-wrappers/mount.ecryptfs_private \
        --replace /sbin/umount.ecryptfs_private /var/setuid-wrappers/umount.ecryptfs_private \
        --replace /sbin/mount.ecryptfs $out/sbin/mount.ecryptfs \
        --replace /sbin/umount.ecryptfs $out/sbin/umount.ecryptfs \
        --replace /usr/bin/ecryptfs-rewrite-file $out/bin/ecryptfs-rewrite-file \
        --replace /usr/bin/ecryptfs-mount-private $out/bin/ecryptfs-mount-private \
        --replace /usr/bin/ecryptfs-setup-private $out/bin/ecryptfs-setup-private \
        --replace /sbin/cryptsetup ${cryptsetup}/sbin/cryptsetup \
        --replace /sbin/dmsetup ${lvm2}/sbin/dmsetup \
        --replace /bin/mount ${utillinux}/bin/mount \
        --replace /bin/umount ${utillinux}/bin/umount \
        --replace /sbin/unix_chkpwd /var/setuid-wrappers/unix_chkpwd \
        --replace /bin/bash ${bash}/bin/bash
    done
  '';

  buildInputs = [ pkgconfig perl nss nspr python pam intltool makeWrapper ];
  propagatedBuildInputs = [ coreutils gettext cryptsetup lvm2 rsync keyutils which ];

  postInstall = ''
    FILES="$(grep -r '/bin/sh' $out/bin -l)"
    for file in $FILES; do
      wrapProgram $file \
        --prefix PATH ":" "${coreutils}/bin" \
        --prefix PATH ":" "${gettext}/bin" \
        --prefix PATH ":" "${rsync}/bin" \
        --prefix PATH ":" "${keyutils}/bin" \
        --prefix PATH ":" "${which}/bin" \
        --prefix PATH ":" "$out/bin"
    done
  '';

  meta = with stdenv.lib; {
    description = "Enterprise-class stacked cryptographic filesystem";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.obadz ];
    platforms = platforms.linux;
  };
}
