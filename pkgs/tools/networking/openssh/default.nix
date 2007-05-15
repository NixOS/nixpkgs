{ stdenv, fetchurl, zlib, openssl, perl
, pamSupport ? false, pam ? null
}:

assert pamSupport -> pam != null;
 
stdenv.mkDerivation {
  name = "openssh-4.6p1";
 
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/security/OpenSSH/openssh-4.6p1.tar.gz;
    sha256 = "0fpjlr3bfind0y94bk442x2ps060byv1s4cnrgcxij40m9zjggkv";
  };
 
  buildInputs = [zlib openssl perl
    (if pamSupport then pam else null)
  ];

  configureFlags = "
    ${if pamSupport then "--with-pam" else ""}
  ";

  preConfigure = "
    configureFlags=\"$configureFlags --with-privsep-path=$out/empty\"
    ensureDir $out/empty
  ";

  postInstall = "
    # Install ssh-copy-id, it's very useful.
    cp contrib/ssh-copy-id $out/bin/
    chmod +x $out/bin/ssh-copy-id
    cp contrib/ssh-copy-id.1 $out/share/man/cat1/
  ";

  installTargets = "install-nokeys";
}
