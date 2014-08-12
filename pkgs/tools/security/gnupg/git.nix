# Remember to install Pinentry and
# 'echo "pinentry-program `which pinentry-gtk-2`" >> ~/.gnupg/gpg-agent.conf'.

{ fetchgit, stdenv, readline, zlib, libgpgerror, npth, libgcrypt, libassuan
, libksba, coreutils, autoconf, automake, transfig, ghostscript, texinfo
, useLdap ? true, openldap ? null, useBzip2 ? true, bzip2 ? null, useUsb ? true
, libusb ? null, useCurl ? true, curl ? null
}:

assert useLdap -> (openldap != null);
assert useBzip2 -> (bzip2 != null);
assert useUsb -> (libusb != null);
assert useCurl -> (curl != null);

stdenv.mkDerivation rec {
  name = "gnupg-2.1pre-git20120407";

  src = fetchgit {
    url = "git://git.gnupg.org/gnupg.git";
    rev = "f1e1387bee286c7434f0462185048872bcdb4484";
    sha256 = "8f5a14587beccdd3752f9e430e56c6ea2d393dddb7843bfc17029e1a309045bb";
  };

  buildInputs = [ readline zlib libgpgerror npth libgcrypt libassuan libksba 
                  autoconf automake transfig ghostscript texinfo ]
    ++ stdenv.lib.optional useLdap openldap
    ++ stdenv.lib.optional useBzip2 bzip2
    ++ stdenv.lib.optional useUsb libusb
    ++ stdenv.lib.optional useCurl curl;

  patchPhase = ''
    find tests -type f | xargs sed -e 's@/bin/pwd@${coreutils}&@g' -i
  '';

  preConfigure = "autoreconf -v";
  configureFlags = "--enable-maintainer-mode";

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

    license = stdenv.lib.licenses.gpl3Plus;
  };
}
