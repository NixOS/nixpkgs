{ # Support for the IDEA cipher (used by the old PGP) should only be
  # enabled if it is legal for you to do so.
  ideaSupport ? false

, stdenv, fetchurl, readline, bzip2
}:

let

  idea = fetchurl {
    url = http://nixos.org/tarballs/idea.c.gz;
    md5 = "9dc3bc086824a8c7a331f35e09a3e57f";
  };

in

stdenv.mkDerivation rec {
  name = "gnupg-1.4.13";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha1 = "17a75c54d292bd0923f0a1817a1b02ded37d1de1";
  };

  buildInputs = [ readline bzip2 ];

  preConfigure = stdenv.lib.optionalString ideaSupport
    ''
      gunzip < ${idea} > ./cipher/idea.c
    '';

  doCheck = true;

  meta = {
    description = "GnuPG, a free implementation of the OpenPGP standard for encrypting and signing data";
    homepage = http://www.gnupg.org/;
    license = "GPLv3+";
    platforms = stdenv.lib.platforms.gnu; # arbitrary choice
  };
}
