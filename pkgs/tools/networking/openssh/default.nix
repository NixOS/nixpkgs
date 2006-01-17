{stdenv, fetchurl, zlib, openssl, xforwarding ? false, xauth ? null}:

assert xforwarding -> xauth != null;
 
stdenv.mkDerivation {
  name = "openssh-3.8.1p1";
 
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/openssh-3.8.1p1.tar.gz;
    md5 = "1dbfd40ae683f822ae917eebf171ca42";
  };
 
  buildInputs = [zlib openssl
  (if xforwarding then xauth else null)
  ];
}
