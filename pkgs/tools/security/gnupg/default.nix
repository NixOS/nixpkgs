# Remember to install Pinentry and
# 'echo "pinentry-program `which pinentry-gtk-2`" >> ~/.gnupg/gpg-agent.conf'.

{ fetchurl, stdenv, readline, zlib, libgpgerror, pth, libgcrypt, libassuan
, libksba, coreutils, libiconvOrEmpty
, useLdap ? true, openldap ? null, useBzip2 ? true, bzip2 ? null
, useUsb ? true, libusb ? null, useCurl ? true, curl ? null
}:

assert useLdap -> (openldap != null);
assert useBzip2 -> (bzip2 != null);
assert useUsb -> (libusb != null);
assert useCurl -> (curl != null);

stdenv.mkDerivation rec {
  name = "gnupg-2.0.26";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "1q5qcl5panrvcvpwvz6nl9gayl5a6vwvfhgdcxqpmbl2qc6y6n3p";
  };

  buildInputs
    = [ readline zlib libgpgerror libgcrypt libassuan libksba pth ]
    ++ libiconvOrEmpty
    ++ stdenv.lib.optional useLdap openldap
    ++ stdenv.lib.optional useBzip2 bzip2
    ++ stdenv.lib.optional useUsb libusb
    ++ stdenv.lib.optional useCurl curl;

  patchPhase = ''
    find tests -type f | xargs sed -e 's@/bin/pwd@${coreutils}&@g' -i
    find . -name pcsc-wrapper.c | xargs sed -i 's/typedef unsinged int pcsc_dword_t/typedef unsigned int pcsc_dword_t/'
    patch gl/stdint_.h < ${./clang.patch}
  '';

  checkPhase="GNUPGHOME=`pwd` ./agent/gpg-agent --daemon make check";

  doCheck = true;

  meta = {
    homepage = "http://gnupg.org/";
    description = "free implementation of the OpenPGP standard for encrypting and signing data";
    license = stdenv.lib.licenses.gpl3Plus;

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

    maintainers = with stdenv.lib.maintainers; [ urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
