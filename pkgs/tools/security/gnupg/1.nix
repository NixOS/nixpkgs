{
  lib,
  stdenv,
  fetchurl,
  readline,
  bzip2,
}:

stdenv.mkDerivation rec {
  pname = "gnupg";
  version = "1.4.23";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/gnupg-${version}.tar.bz2";
    sha256 = "1fkq4sqldvf6a25mm2qz95swv1qjg464736091w51djiwqbjyin9";
  };

  buildInputs = [
    readline
    bzip2
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: ../util/libutil.a(estream-printf.o):/build/gnupg-1.4.23/util/../include/memory.h:100: multiple definition of
  #     `memory_debug_mode'; gpgsplit.o:/build/gnupg-1.4.23/tools/../include/memory.h:100: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  doCheck = true;

  meta = with lib; {
    homepage = "https://gnupg.org";
    description = "Classic (1.4) release of the GNU Privacy Guard, a GPL OpenPGP implementation";
    license = licenses.gpl3Plus;
    longDescription = ''
      The GNU Privacy Guard is the GNU project's complete and free
      implementation of the OpenPGP standard as defined by RFC4880.  GnuPG
      "classic" (1.4) is the old standalone version which is most suitable for
      older or embedded platforms.  GnuPG allows to encrypt and sign your data
      and communication, features a versatile key management system as well as
      access modules for all kind of public key directories.  GnuPG, also known
      as GPG, is a command line tool with features for easy integration with
      other applications.  A wealth of frontend applications and libraries are
      available.
    '';
    platforms = platforms.all;
    mainProgram = "gpg";
  };
}
