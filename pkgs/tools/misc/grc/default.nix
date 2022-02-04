{ lib
, fetchFromGitHub
, buildPythonApplication
}:

buildPythonApplication rec {
  pname = "grc";
  version = "1.13";
  format = "other";

  src = fetchFromGitHub {
    owner = "garabik";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h0h88h484a9796hai0wasi1xmjxxhpyxgixn6fgdyc5h69gv8nl";
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
    homepage = "http://kassiopeia.juls.savba.sk/~garabik/software/grc.html";
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
