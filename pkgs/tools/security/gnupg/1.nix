{ stdenv, fetchurl, readline, bzip2 }:

stdenv.mkDerivation rec {
  name = "gnupg-1.4.22";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "1d1hz4szh1kvwhsw7w2zxa6q5ndrk3qy6hj289l1b8k3xi5s554m";
  };

  buildInputs = [ readline bzip2 ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://gnupg.org;
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
    platforms = platforms.gnu; # arbitrary choice
  };
}
