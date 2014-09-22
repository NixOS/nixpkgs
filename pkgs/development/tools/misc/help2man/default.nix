{ stdenv, fetchurl, perl, gettext, LocaleGettext, makeWrapper }:

stdenv.mkDerivation rec {
  name = "help2man-1.46.2";

  src = fetchurl {
    url = "mirror://gnu/help2man/${name}.tar.xz";
    sha256 = "0483cpizy0mqngibv56p6p8jxwh8678qksf5zs5wh963r3n1s6cj";
  };

  buildInputs = [ makeWrapper perl gettext LocaleGettext ];

  doCheck = false;                                # target `check' is missing

  postInstall =
    '' wrapProgram "$out/bin/help2man" \
         --prefix PERL5LIB : "$(echo ${LocaleGettext}/lib/perl*/site_perl)"
    '';


  meta = with stdenv.lib; {
    description = "Generate man pages from `--help' output";

    longDescription =
      '' help2man produces simple manual pages from the ‘--help’ and
         ‘--version’ output of other commands.
      '';

    homepage = http://www.gnu.org/software/help2man/;

    license = licenses.gpl3Plus;
    platforms = platforms.gnu;         # arbitrary choice
    maintainers = with maintainers; [ ludo pSub ];
  };
}
