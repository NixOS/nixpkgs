# remmeber to
# echo "pinentry-program `which pinentry-gtk-2`" >> ~/.gnupg/gpg-agent.conf
# and install pinentry as well

args: with args;
stdenv.mkDerivation {
  name = "gnupg-2.0.8";
  src = fetchurl {
    url = ftp://ftp.cert.dfn.de/pub/tools/crypt/gcrypt/gnupg/gnupg-2.0.8.tar.bz2;
    sha256 = "04v9s92xph1hrhac49yyrgzdwjqshs2zawvjbi3jc2klwjpi1wqn";
  };
  buildInputs = [ readline openldap bzip2 zlib libgpgerror pth libgcrypt
    libassuan libksba libusb curl ];

  meta = {
    description = "A free implementation of the OpenPGP standard for encrypting
	and signing data, v2";
    homepage = http://www.gnupg.org/;
  };
}
