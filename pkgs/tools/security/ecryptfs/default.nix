{ lib, stdenv, fetchurl, pkg-config, perl, util-linux, keyutils, nss, nspr, python2, pam, enablePython ? false
, intltool, makeWrapper, coreutils, bash, gettext, cryptsetup, lvm2, rsync, which, lsof, nixosTests }:

stdenv.mkDerivation rec {
  pname = "ecryptfs";
  version = "111";

  src = fetchurl {
    url = "https://launchpad.net/ecryptfs/trunk/${version}/+download/ecryptfs-utils_${version}.orig.tar.gz";
    sha256 = "0zwq19siiwf09h7lwa7n7mgmrr8cxifp45lmwgcfr8c1gviv6b0i";
  };

  # TODO: replace wrapperDir below with from <nixos> config.security.wrapperDir;
  wrapperDir = "/run/wrappers/bin";

  postPatch = ''
    FILES="$(grep -r '/bin/sh' src/utils -l; find src -name \*.c)"
    for file in $FILES; do
      substituteInPlace "$file" \
        --replace-fail /bin/mount ${util-linux}/bin/mount \
        --replace-fail /bin/umount ${util-linux}/bin/umount \
        --replace-fail /sbin/mount.ecryptfs_private ${wrapperDir}/mount.ecryptfs_private \
        --replace-fail /sbin/umount.ecryptfs_private ${wrapperDir}/umount.ecryptfs_private \
        --replace-fail /sbin/mount.ecryptfs $out/sbin/mount.ecryptfs \
        --replace-fail /sbin/umount.ecryptfs $out/sbin/umount.ecryptfs \
        --replace-fail /usr/bin/ecryptfs-rewrite-file $out/bin/ecryptfs-rewrite-file \
        --replace-fail /usr/bin/ecryptfs-mount-private $out/bin/ecryptfs-mount-private \
        --replace-fail /usr/bin/ecryptfs-setup-private $out/bin/ecryptfs-setup-private \
        --replace-fail /sbin/cryptsetup ${cryptsetup}/sbin/cryptsetup \
        --replace-fail /sbin/dmsetup ${lvm2}/sbin/dmsetup \
        --replace-fail /sbin/unix_chkpwd ${wrapperDir}/unix_chkpwd \
        --replace-fail /bin/bash ${bash}/bin/bash
    done
  '';

  configureFlags = lib.optionals (!enablePython) [ "--disable-pywrap" ];

  nativeBuildInputs = [ pkg-config makeWrapper intltool ]
  # if python2 support is requested, it is needed at builtime as well as runtime.
  ++ lib.optionals (enablePython) [ python2 ]
  ;
  buildInputs = [ perl nss nspr pam ]
  ++ lib.optionals (enablePython) [ python2 ]
  ;
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
        --prefix PATH ":" "${lsof}/bin" \
        --prefix PATH ":" "$out/bin"
    done
  '';

  passthru.tests = { inherit (nixosTests) ecryptfs; };

  meta = with lib; {
    description = "Enterprise-class stacked cryptographic filesystem";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ obadz ];
    platforms   = platforms.linux;
  };
}
