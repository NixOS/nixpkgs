{ stdenv, fetchFromGitHub, python3Packages, makeWrapper }:

stdenv.mkDerivation rec {
  name    = "grc-${version}";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner  = "garabik";
    repo   = "grc";
    rev    = "v${version}";
    sha256 = "10h65qmv2cymixzfsckfcn6f01xsjzfq1x303rv01nibniwbq5z9";
  };

  buildInputs = with python3Packages; [ wrapPython makeWrapper ];

  installPhase = ''
    runHook preInstall

    ./install.sh "$out" "$out"

    for f in $out/bin/* ; do
      patchPythonScript $f
      substituteInPlace $f \
        --replace ' /usr/bin/env python3' '${python3Packages.python.interpreter}' \
        --replace "'/etc/grc.conf'"   "'$out/etc/grc.conf'" \
        --replace "'/usr/share/grc/'" "'$out/share/grc/'"
      wrapProgram $f \
        --prefix PATH : $out/bin
    done

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Yet another colouriser for beautifying your logfiles or output of commands";
    homepage    = http://korpus.juls.savba.sk/~garabik/software/grc.html;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 AndersonTorres peterhoeg ];
    platforms   = platforms.unix;

    longDescription = ''
      Generic Colouriser is yet another colouriser (written in Python) for
      beautifying your logfiles or output of commands.
    '';
  };
}
