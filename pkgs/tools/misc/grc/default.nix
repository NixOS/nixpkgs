{ lib, fetchFromGitHub, buildPythonApplication }:

buildPythonApplication rec {
  pname = "grc";
  version = "1.12";
  format = "other";

  src = fetchFromGitHub {
    owner = "garabik";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XJj1j6sDt0iL3U6uMbB1j0OfpXRdP+x66gc6sKxrQIA=";
  };

  postPatch = ''
    for f in grc grcat; do
      substituteInPlace $f \
        --replace /usr/local/ $out/
    done
  '';

  installPhase = ''
    runHook preInstall
    ./install.sh "$out" "$out"
    install -Dm444 -t $out/share/zsh/vendor-completions _grc
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://korpus.juls.savba.sk/~garabik/software/grc.html";
    description = "A generic text colouriser";
    longDescription = ''
      Generic Colouriser is yet another colouriser (written in Python) for
      beautifying your logfiles or output of commands.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 AndersonTorres peterhoeg ];
    platforms = platforms.unix;
  };
}
