{ stdenv, fetchurl, perl, gettext, LocaleGettext, makeWrapper }:

stdenv.mkDerivation rec {
  name = "help2man-1.40.8";

  src = fetchurl {
    url = "mirror://gnu/help2man/${name}.tar.gz";
    sha256 = "0s6phazn8jgvpbsby8kj2m58rj1zjghi1aipvamh8af226ssqfzj";
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
