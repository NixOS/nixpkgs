{stdenv, fetchurl, zlib, openssl, xforwarding ? false, xauth ? null}:

assert xforwarding -> xauth != null;
 
stdenv.mkDerivation {
  name = "openssh-4.3p2";
 
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/security/OpenSSH/openssh-4.3p2.tar.gz;
    md5 = "7e9880ac20a9b9db0d3fea30a9ff3d46";
  };
 
  buildInputs = [zlib openssl
  (if xforwarding then xauth else null)
  ];
}
