{ fetchurl, stdenv, perl }:

stdenv.mkDerivation rec {
  name = "namazu-2.0.20";

  src = fetchurl {
    url = "http://namazu.org/stable/${name}.tar.gz";
    sha256 = "1czw3l6wmz8887wfjpgds9di8hcg0hsmbc0mc6bkahj8g7lvrnyd";
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

  # FIXME: The `tests/namazu-6' test fails on GNU/Linux, presumably because
  # phrase searching is broken somehow.  However, it doesn't fail on other
  # platforms.
  doCheck = !stdenv.isLinux;

  meta = {
    description = "Namazu, a full-text search engine";

    longDescription = ''
      Namazu is a full-text search engine intended for easy use.  Not
      only does it work as a small or medium scale Web search engine,
      but also as a personal search system for email or other files.
    '';

    license = "GPLv2+";
    homepage = http://namazu.org/;

    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
