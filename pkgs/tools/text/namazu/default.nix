{ fetchurl, stdenv, perl }:

stdenv.mkDerivation rec {
  name = "namazu-2.0.21";

  src = fetchurl {
    url = "http://namazu.org/stable/${name}.tar.gz";
    sha256 = "1xvi7hrprdchdpzhg3fvk4yifaakzgydza5c0m50h1yvg6vay62w";
  };

  buildInputs = [ perl ];

  # First install the `File::MMagic' Perl module.
  preConfigure = ''
    ( cd File-MMagic &&                              \
      perl Makefile.PL                               \
        LIB="$out/${perl.libPrefix}/${perl.version}" \
        INSTALLSITEMAN3DIR="$out/man" &&             \
      make && make install )
    export PERL5LIB="$out/${perl.libPrefix}/${perl.version}:$PERL5LIB"
  '';

  # FIXME: The `tests/namazu-6' test fails on GNU/Linux, presumably because
  # phrase searching is broken somehow.  However, it doesn't fail on other
  # platforms.
  doCheck = !stdenv.isLinux;

  meta = {
    description = "Full-text search engine";

    longDescription = ''
      Namazu is a full-text search engine intended for easy use.  Not
      only does it work as a small or medium scale Web search engine,
      but also as a personal search system for email or other files.
    '';

    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://namazu.org/;

    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.linux;  # arbitrary choice
    maintainers = [ ];
    broken = true; # File-MMagic is not compatible with our Perl version
  };
}
