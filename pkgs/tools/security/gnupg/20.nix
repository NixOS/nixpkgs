{ fetchurl, stdenv, readline, zlib, libgpgerror, pth, libgcrypt, libassuan
, libksba, coreutils, libiconv, pcsclite

# Each of the dependencies below are optional.
# Gnupg can be built without them at the cost of reduced functionality.
, pinentry ? null, guiSupport ? true
, openldap ? null, bzip2 ? null, libusb ? null, curl ? null
}:

with stdenv.lib;

assert guiSupport -> pinentry != null;

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

  pinentryBinaryPath = pinentry.binaryPath or "bin/pinentry";
  configureFlags = optional guiSupport "--with-pinentry-pgm=${pinentry}/${pinentryBinaryPath}";

  postConfigure = "substituteAllInPlace tools/gpgkey2ssh.c";

  checkPhase="GNUPGHOME=`pwd` ./agent/gpg-agent --daemon make check";

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://gnupg.org";
    description = "Stable (2.0) release of the GNU Privacy Guard, a GPL OpenPGP implementation";
    license = licenses.gpl3Plus;
    longDescription = ''
      The GNU Privacy Guard is the GNU project's complete and free
      implementation of the OpenPGP standard as defined by RFC4880.  GnuPG
      "stable" (2.0) is the current stable version for general use.  This is
      what most users are still using.  GnuPG allows to encrypt and sign your
      data and communication, features a versatile key management system as well
      as access modules for all kind of public key directories.  GnuPG, also
      known as GPG, is a command line tool with features for easy integration
      with other applications.  A wealth of frontend applications and libraries
      are available.  Version 2 of GnuPG also provides support for S/MIME.
    '';
    maintainers = with maintainers; [ roconnor ];
    platforms = platforms.all;
  };
}
