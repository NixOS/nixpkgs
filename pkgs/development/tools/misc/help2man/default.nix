{stdenv, fetchurl, perl, gettext, LocaleGettext}:

stdenv.mkDerivation rec {
  name = "help2man-1.40.5";

  src = fetchurl {
    url = "mirror://gnu/help2man/${name}.tar.gz";
    sha256 = "1d1wn9krvf9mp97c224710n1pcfh73p7w7na65zn2a06124rln8k";
  };

  buildInputs = [
    perl
    gettext
    LocaleGettext
  ];

  doCheck = false;                                # target `check' is missing

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
