{
  lib,
  fetchFromGitHub,
  buildPythonApplication,
  installShellFiles,
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

    # Support for absolute store paths.
    substituteInPlace grc.conf \
      --replace "^([/\w\.]+\/)" "^([/\w\.\-]+\/)"
  '';

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    ./install.sh "$out" "$out"
    installShellCompletion --zsh --name _grc _grc

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://kassiopeia.juls.savba.sk/~garabik/software/grc.html";
    description = "Generic text colouriser";
    longDescription = ''
      Generic Colouriser is yet another colouriser (written in Python) for
      beautifying your logfiles or output of commands.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      azahi
      lovek323
      peterhoeg
    ];
    platforms = platforms.unix;
    mainProgram = "grc";
  };
}
