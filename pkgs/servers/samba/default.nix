args: with args;

stdenv.mkDerivation {
  name = "samba-3.0.26a";

  src = fetchurl {
    url = http://us1.samba.org/samba/ftp/stable/samba-3.0.26a.tar.gz;
    sha256 = "41e11f69288b2291f12f8db093e2c55dc1360555d4542c83c0758c4c7a3d4d37";
  };

  buildInputs = [readline pam openldap];
  configureFlags = "--with-pam --with-smbmount";
  postUnpack = "sourceRoot=\$sourceRoot/source";
}
