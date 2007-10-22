{ stdenv, fetchurl, zlib, openssl, perl
, pamSupport ? false, pam ? null
}:

assert pamSupport -> pam != null;
 
stdenv.mkDerivation {
  name = "openssh-4.7p1";
 
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/security/OpenSSH/openssh-4.7p1.tar.gz;
    sha256 = "1g28npm025a5a8dd2g7sqz8nh8pwi7rvv9wdpy4jhzbkqvq36wfl";
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
  ";

  postInstall = "
    # Install ssh-copy-id, it's very useful.
    cp contrib/ssh-copy-id $out/bin/
    chmod +x $out/bin/ssh-copy-id
    cp contrib/ssh-copy-id.1 $out/share/man/man1/
  ";

  installTargets = "install-nokeys";
}
