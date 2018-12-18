{ stdenv, fetchurl, perlPackages, gettext }:

stdenv.mkDerivation rec {
  name = "help2man-1.47.8";

  src = fetchurl {
    url = "mirror://gnu/help2man/${name}.tar.xz";
    sha256 = "1p5830h88cx0zn0snwaj0vpph81xicpsirfwlxmcgjrlmn0nm3sj";
  };

  nativeBuildInputs = [ gettext perlPackages.LocaleGettext ];
  buildInputs = [ perlPackages.perl perlPackages.LocaleGettext ];

  doCheck = false;                                # target `check' is missing

  patches = if stdenv.hostPlatform.isCygwin then [ ./1.40.4-cygwin-nls.patch ] else null;

  # We don't use makeWrapper here because it uses substitutions our
  # bootstrap shell can't handle.
  postInstall = ''
    mv $out/bin/help2man $out/bin/.help2man-wrapped
    cat > $out/bin/help2man <<EOF
    #! $SHELL -e
    export PERL5LIB=\''${PERL5LIB:+:}${perlPackages.LocaleGettext}/${perlPackages.perl.libPrefix}
    ${stdenv.lib.optionalString stdenv.hostPlatform.isCygwin
        ''export PATH=\''${PATH:+:}${gettext}/bin''}
    exec -a \$0 $out/bin/.help2man-wrapped "\$@"
    EOF
    chmod +x $out/bin/help2man
  '';

  meta = with stdenv.lib; {
    description = "Generate man pages from `--help' output";

    longDescription =
      '' help2man produces simple manual pages from the ‘--help’ and
         ‘--version’ output of other commands.
      '';

    homepage = https://www.gnu.org/software/help2man/;

    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };
}
