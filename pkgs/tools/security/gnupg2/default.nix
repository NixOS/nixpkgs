# Remember to install Pinentry and
# 'echo "pinentry-program `which pinentry-gtk-2`" >> ~/.gnupg/gpg-agent.conf'.

{ fetchurl, stdenv, readline, openldap, bzip2, zlib, libgpgerror
, pth, libgcrypt, libassuan, libksba, libusb, curl }:

stdenv.mkDerivation rec {
  name = "gnupg-2.0.10";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "08yz2kgcnphjml5mhq4bm4dg64jrz79p97nlrlb88ym6p6ybg26l";
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
  };
}
