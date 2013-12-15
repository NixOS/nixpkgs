{ stdenv, fetchurl, perl, gettext, LocaleGettext, makeWrapper }:

stdenv.mkDerivation rec {
  name = "help2man-1.43.3";

  src = fetchurl {
    url = "mirror://gnu/help2man/${name}.tar.gz";
    sha256 = "00yk86rvvaavg7y6i5bvk5xhm417jl9dpr8bqvqdksw0i48qv5v7";
  };

  buildInputs = [ makeWrapper perl gettext LocaleGettext ];

  doCheck = false;                                # target `check' is missing

  postInstall =
    '' wrapProgram "$out/bin/help2man" \
         --prefix PERL5LIB : "$(echo ${LocaleGettext}/lib/perl*/site_perl)"
    '';


  meta = {
    description = "GNU help2man generates man pages from `--help' output";

    longDescription =
      '' help2man produces simple manual pages from the ‘--help’ and
         ‘--version’ output of other commands.
      '';

    homepage = http://www.gnu.org/software/help2man/;

    license = "GPLv3+";
    platforms = stdenv.lib.platforms.gnu;         # arbitrary choice
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
