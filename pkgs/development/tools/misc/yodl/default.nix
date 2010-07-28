# This package is only used to create the documentation of zsh-cvs
# eg have a look at http://www.zsh.org/mla/users/2008/msg00715.html
# latest release is newer though

{ stdenv, fetchurl, perl }:

stdenv.mkDerivation {
  name = "yodl-2.14.3";

  buildInputs = [ perl ];

  src = fetchurl {
    url = "mirror://sourceforge/yodl/yodl_2.14.3.orig.tar.gz";
    sha256 = "0paypm76p34hap3d18vvks5rrilchcw6q56rvq6pjf9raqw8ynd4";
  };
  
  patches =
    [ (fetchurl {
        url = "mirror://sourceforge/yodl/yodl_2.14.3-1.diff.gz";
        sha256 = "176hlbiidv7p9051f04anzj4sr9dwlp9439f9mjvvgks47ac0qx4";
      })
    ];

  # This doesn't isntall docs yet, do you need them?
  installPhase = ''
    # -> $out
    sed -i "s@'/usr/@'$out/@" contrib/build.pl
    perl contrib/build.pl make-software
    perl contrib/build.pl install-software
  '';
}
