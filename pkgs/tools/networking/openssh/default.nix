{ stdenv, fetchurl, zlib, openssl, perl
, pamSupport ? false, pam ? null
, xforwarding ? false, xauth ? null
}:

assert pamSupport -> pam != null;
assert xforwarding -> xauth != null;
 
stdenv.mkDerivation {
  name = "openssh-3.8.1p1";
 
  #builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/openssh-3.8.1p1.tar.gz;
    md5 = "1dbfd40ae683f822ae917eebf171ca42";
  };
 
  buildInputs = [zlib openssl perl
    (if pamSupport then pam else null)
    (if xforwarding then xauth else null)
  ];

  configureFlags = "
    ${if xforwarding then "--with-xauth=${xauth}/bin/xauth" else ""}
    ${if pamSupport then "--with-pam" else ""}
  ";

  preConfigure = "
    configureFlags=\"$configureFlags --with-privsep-path=$out/empty\"
    ensureDir $out/empty
  ";

  installPhase = "make install-nokeys"; # !!! patchelf etc.
}
