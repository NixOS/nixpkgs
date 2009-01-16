# This package is only used to create the documentation of zsh-cvs
# eg have a look at http://www.zsh.org/mla/users/2008/msg00715.html
# latest release is newer though
args: with args;
stdenv.mkDerivation {
  name = "yodl-2.13.2";

  buildInputs = [perl];

  src = fetchurl {
    url = "mirror://sourceforge/sourceforge/yodl/yodl_2.13.2.orig.tar.gz";
    sha256 = "07zzyx8vf27y3p549qza0pqrb61hfh0gynxqb8i1cghjmxhrlxj3";
  };
  # maybe apply diff?

  # This doesn't isntall docs yet, do you need them?
  installPhase = ''
    # -> $out
    sed -i "s@'/usr/@'$out/@" contrib/build.pl
    perl contrib/build.pl make-software
    perl contrib/build.pl install-software
  '';
}
