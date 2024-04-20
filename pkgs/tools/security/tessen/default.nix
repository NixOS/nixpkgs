{ lib
, stdenvNoCC
, fetchFromSourcehut
, makeWrapper
, installShellFiles
, wtype
, wl-clipboard
, pass
, bemenu
, scdoc
}:

stdenvNoCC.mkDerivation rec {
  pname = "tessen";
  version = "2.2.3";

  src = fetchFromSourcehut {
    owner = "~ayushnix";
    repo  = pname;
    rev = "v${version}";
    sha256  = "sha256-mVGsI1JBG7X8J7gqocdfxWuTVSZpxS23QPGHCUofvV8=";
  };

  nativeBuildInputs = [ makeWrapper installShellFiles scdoc ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D tessen $out/bin/tessen
    wrapProgram $out/bin/tessen --prefix PATH : ${ lib.makeBinPath [ bemenu pass wtype wl-clipboard ] }
    runHook postInstall
  '';

  postInstall = ''
    scdoc < man/tessen.1.scd > man/tessen.1
    scdoc < man/tessen.5.scd > man/tessen.5
    installManPage man/*.{1,5}
    installShellCompletion --cmd tessen \
      --bash completion/tessen.bash-completion \
      --fish completion/tessen.fish-completion
    install -Dm644 config $out/share/tessen/config
  '';

  meta = with lib; {
    homepage = "https://sr.ht/~ayushnix/tessen";
    description = "An interactive menu to autotype and copy Pass and GoPass data";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ monaaraj ];
    mainProgram = "tessen";
  };
}
