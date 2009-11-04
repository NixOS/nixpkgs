{ stdenv, fetchurl, zlib, openssl, perl
, pamSupport ? false, pam ? null
, etcDir ? null
, hpnSupport ? false
}:

assert pamSupport -> pam != null;

stdenv.mkDerivation (rec {
  name = "openssh-5.2p1";

  src = fetchurl {
    url = "ftp://ftp.nluug.nl/pub/security/OpenSSH/${name}.tar.gz";
    sha256 = "1bpc6i07hlakb9vrxr8zb1yxnc9avsv7kjwrcagdgcyh6w6728s0";
  };

  buildInputs = [zlib openssl perl
    (if pamSupport then pam else null)
  ];

  configureFlags = "
    --with-mantype=man
    ${if pamSupport then "--with-pam" else "--without-pam"}
    ${if etcDir != null then "--sysconfdir=${etcDir}" else ""}
  ";

  preConfigure = "
    configureFlags=\"$configureFlags --with-privsep-path=$out/empty\"
    ensureDir $out/empty
  ";

  postInstall = "
    # Install ssh-copy-id, it's very useful.
    cp contrib/ssh-copy-id $out/bin/
    chmod +x $out/bin/ssh-copy-id
    cp contrib/ssh-copy-id.1 $out/share/man/man1/
  ";

  installTargets = "install-nosysconf";
} //
(if hpnSupport then
rec {
   hpnSrc = fetchurl {
     url = http://www.psc.edu/networking/projects/hpn-ssh/openssh-5.2p1-hpn13v6.diff.gz;
     sha256 = "1g91xl1vfg772072qcbcfzyqj7yfvm38xgk8zyy8wsl2g81rb8wh";
   };

   patchPhase = ''
     gunzip -c ${hpnSrc} | patch -p1
   '';
}
else {}))
