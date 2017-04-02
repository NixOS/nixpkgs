{ stdenv, fetchFromGitHub, python3Packages, makeWrapper }:

stdenv.mkDerivation rec {
  name    = "grc-${version}";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner  = "garabik";
    repo   = "grc";
    rev    = "v${version}";
    sha256 = "1c2ndnbyznb608h3s99fbcyh4qb1ccipxm15lyszrrks0w2llbah";
  };

  buildInputs = with python3Packages; [ wrapPython makeWrapper ];

  installPhase = ''
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
  '';

  meta = with stdenv.lib; {
    description = "Yet another colouriser for beautifying your logfiles or output of commands";
    homepage    = http://korpus.juls.savba.sk/~garabik/software/grc.html;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 AndersonTorres ];
    platforms   = platforms.unix;

    longDescription = ''
      Generic Colouriser is yet another colouriser (written in Python) for
      beautifying your logfiles or output of commands.
    '';
  };
}
