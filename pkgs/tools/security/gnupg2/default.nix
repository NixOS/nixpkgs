# Remember to install Pinentry and
# 'echo "pinentry-program `which pinentry-gtk-2`" >> ~/.gnupg/gpg-agent.conf'.

{ fetchurl, stdenv, readline, openldap, bzip2, zlib, libgpgerror
, pth, libgcrypt, libassuan, libksba, libusb, curl }:

stdenv.mkDerivation rec {
  name = "gnupg-2.0.11";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "0z5lm0zz8l8yn61jbbyy0frrbhsjyvmq8pxwhgjsgx3isj518h4c";
  };

  buildInputs = [ readline openldap bzip2 zlib libgpgerror pth libgcrypt
    libassuan libksba libusb curl ];

  doCheck = true;

  meta = {
    description = "GNU Privacy Guard (GnuPG), GNU Project's implementation of the OpenPGP standard";

    longDescription = ''
      GnuPG is the GNU project's complete and free implementation of
      the OpenPGP standard as defined by RFC4880.  GnuPG allows to
      encrypt and sign your data and communication, features a
      versatile key managment system as well as access modules for all
      kind of public key directories.  GnuPG, also known as GPG, is a
      command line tool with features for easy integration with other
      applications.  A wealth of frontend applications and libraries
      are available.  Version 2 of GnuPG also provides support for
      S/MIME.
    '';

    homepage = http://gnupg.org/;

    license = "GPLv3+";
  };
}
