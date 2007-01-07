{ stdenv, fetchurl, zlib, openssl, perl
, pamSupport ? false, pam ? null
}:

assert pamSupport -> pam != null;
 
stdenv.mkDerivation {
  name = "openssh-4.5p1";
 
  src = fetchurl {
    url = ftp://sunsite.cnlab-switch.ch/pub/OpenBSD/OpenSSH/portable/openssh-4.5p1.tar.gz;
    md5 = "6468c339886f78e8a149b88f695839dd";
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

  installTargets = "install-nokeys";
}
