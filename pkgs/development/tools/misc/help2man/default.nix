{ stdenv, hostPlatform, fetchurl, perl, gettext, LocaleGettext, makeWrapper }:

stdenv.mkDerivation rec {
  name = "help2man-1.47.4";

  src = fetchurl {
    url = "mirror://gnu/help2man/${name}.tar.xz";
    sha256 = "0lvp4306f5nq08f3snffs5pp1zwv8l35z6f5g0dds51zs6bzdv6l";
  };

  buildInputs = [ makeWrapper perl gettext LocaleGettext ];

  doCheck = false;                                # target `check' is missing

  patches = if hostPlatform.isCygwin then [ ./1.40.4-cygwin-nls.patch ] else null;

  postInstall =
    '' wrapProgram "$out/bin/help2man" \
         --prefix PERL5LIB : "$(echo ${LocaleGettext}/lib/perl*/site_perl)" \
         ${stdenv.lib.optionalString hostPlatform.isCygwin "--prefix PATH : ${gettext}/bin"}
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
