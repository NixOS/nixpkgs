{ stdenv, fetchurl, perl, gettext, LocaleGettext, makeWrapper }:

stdenv.mkDerivation rec {
  name = "help2man-1.47.4";

  src = fetchurl {
    url = "mirror://gnu/help2man/${name}.tar.xz";
    sha256 = "0miqq77ssk5rgsc9xlv7k5n2wk2c5wv2m1kh4zhbwrggfmjaycn2";
  };

  buildInputs = [ makeWrapper perl gettext LocaleGettext ];

  doCheck = false;                                # target `check' is missing

  patches = if stdenv.isCygwin then [ ./1.40.4-cygwin-nls.patch ] else null;

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
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };
}
