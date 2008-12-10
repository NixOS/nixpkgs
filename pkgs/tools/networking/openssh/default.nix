{ stdenv, fetchurl, zlib, openssl, perl
, pamSupport ? false, pam ? null
}:

assert pamSupport -> pam != null;
 
stdenv.mkDerivation {
  name = "openssh-5.1p1";
 
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/security/OpenSSH/openssh-5.1p1.tar.gz;
    sha256 = "0xbdcsjji7i952jfm6wc3xxblp4zbqxfayz5d8w2245f9lb5hlzh";
  };
 
  buildInputs = [zlib openssl perl
    (if pamSupport then pam else null)
  ];

  configureFlags = "
    --with-mantype=man
    ${if pamSupport then "--with-pam" else ""}
  ";

  preConfigure = "
    configureFlags=\"$configureFlags --with-privsep-path=$out/empty\"
    ensureDir $out/empty
    substituteInPlace pathnames.h --replace 'SSHDIR \"/ssh_config\"' '\"/etc/ssh/ssh_config\"'
  ";

  postInstall = "
    # Install ssh-copy-id, it's very useful.
    cp contrib/ssh-copy-id $out/bin/
    chmod +x $out/bin/ssh-copy-id
    cp contrib/ssh-copy-id.1 $out/share/man/man1/
  ";

  installTargets = "install-nokeys";
}
