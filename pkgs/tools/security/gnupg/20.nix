{ fetchurl, stdenv, readline, zlib, libgpgerror, pth, libgcrypt, libassuan
, libksba, coreutils, libiconv, pcsclite

# Each of the dependencies below are optional.
# Gnupg can be built without them at the cost of reduced functionality.
, pinentry ? null, x11Support ? true
, openldap ? null, bzip2 ? null, libusb ? null, curl ? null
}:

with stdenv.lib;

assert x11Support -> pinentry != null;

stdenv.mkDerivation rec {
  name = "gnupg-2.0.30";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "0wax4cy14hh0h7kg9hj0hjn9424b71z8lrrc5kbsasrn9xd7hag3";
  };

  buildInputs
    = [ readline zlib libgpgerror libgcrypt libassuan libksba pth
        openldap bzip2 libusb curl libiconv ];

  patches = [ ./gpgkey2ssh-20.patch ];

  prePatch = ''
    find tests -type f | xargs sed -e 's@/bin/pwd@${coreutils}&@g' -i
  '' + stdenv.lib.optionalString stdenv.isLinux ''
    sed -i 's,"libpcsclite\.so[^"]*","${pcsclite}/lib/libpcsclite.so",g' scd/scdaemon.c
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    find . -name pcsc-wrapper.c | xargs sed -i 's/typedef unsinged int pcsc_dword_t/typedef unsigned int pcsc_dword_t/'
  '' + ''
    patch gl/stdint_.h < ${./clang.patch}
  '';

  configureFlags = optional x11Support "--with-pinentry-pgm=${pinentry}/bin/pinentry";

  postConfigure = "substituteAllInPlace tools/gpgkey2ssh.c";

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
      versatile key management system as well as access modules for all
      kind of public key directories.  GnuPG, also known as GPG, is a
      command line tool with features for easy integration with other
      applications.  A wealth of frontend applications and libraries
      are available.  Version 2 of GnuPG also provides support for
      S/MIME.
    '';

    maintainers = with stdenv.lib.maintainers; [ roconnor urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
