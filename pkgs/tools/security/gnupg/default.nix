# Remember to install Pinentry and
# 'echo "pinentry-program `which pinentry-gtk-2`" >> ~/.gnupg/gpg-agent.conf'.

{ fetchurl, stdenv, readline, zlib, libgpgerror, pth, libgcrypt, libassuan, libksba
, useLdap ? true, openldap ? null, useBzip2 ? true, bzip2 ? null, useUsb ? true, libusb ? null
, useCurl ? true, curl ? null
}:

assert useLdap -> (openldap != null);
assert useBzip2 -> (bzip2 != null);
assert useUsb -> (libusb != null);
assert useCurl -> (curl != null);

stdenv.mkDerivation rec {
  name = "gnupg-2.0.15";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "070diybdiwf45d8xqbb5lwf3jjvhja1lcr6sf4fcw8519lpqi0aq";
  };

  buildInputs = [ readline zlib libgpgerror pth libgcrypt libassuan libksba ]
    ++ stdenv.lib.optional useLdap openldap
    ++ stdenv.lib.optional useBzip2 bzip2
    ++ stdenv.lib.optional useUsb libusb
    ++ stdenv.lib.optional useCurl curl;

  patchPhase = "sed -e 's@/bin/pwd@pwd@g' -i tests/pkits/*";

  postInstall = ''
    ln -s gpg2 $out/bin/gpg
    ln -s gpgv2 $out/bin/gpgv
  '';

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

    maintainers = with stdenv.lib.maintainers; [ ludo urkud ];
  };
}
