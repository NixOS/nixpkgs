args: with args;

stdenv.mkDerivation rec {
  name = "gnupg-" + version;

  src = fetchurl {
    url = "ftp://ftp.cert.dfn.de/pub/tools/crypt/gcrypt/gnupg/${name}.tar.bz2";
    sha256 = "04v9s92xph1hrhac49yyrgzdwjqshs2zawvjbi3jc2klwjpi1wqn";
  };

  buildInputs = [ readline openldap bzip2 zlib libgpgerror pth libgcrypt
    libassuan libksba libusb curl ];

  postInstall = "ln -s gpg2 $out/bin/gpg; ln -s gpgv2 $out/bin/gpgv";

  patches = ./idea.patch;

  meta = {
    description = "A free implementation of the OpenPGP standard for encrypting
    and signing data, v2";
    homepage = http://www.gnupg.org/;
  };
}
