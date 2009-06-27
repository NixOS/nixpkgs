{ fetchurl, stdenv, perl }:

stdenv.mkDerivation rec {
  name = "namazu-2.0.18";

  src = fetchurl {
    url = "http://namazu.org/stable/${name}.tar.gz";
    sha256 = "12i5z830yh5sw3087gmna44742gcw2q7lpj6b94k8fj0h45cm26j";
  };

  buildInputs = [ perl ];

  # First install the `File::MMagic' Perl module.
  # !!! this shouldn't refer to Perl 5.10.0!
  preConfigure = ''
    ( cd File-MMagic &&				\
      perl Makefile.PL				\
        LIB="$out/lib/perl5/site_perl/5.10.0"	\
        INSTALLSITEMAN3DIR="$out/man" &&	\
      make && make install )
    export PERL5LIB="$out/lib/perl5/site_perl/5.10.0:$PERL5LIB"
  '';

  doCheck = true;

  meta = {
    description = "Namazu, a full-text search engine";

    longDescription = ''
      Namazu is a full-text search engine intended for easy use.  Not
      only does it work as a small or medium scale Web search engine,
      but also as a personal search system for email or other files.
    '';

    license = "GPLv2+";
    homepage = http://namazu.org/;
  };
}
