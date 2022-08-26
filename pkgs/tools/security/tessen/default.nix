{ lib
, stdenvNoCC
, fetchFromSourcehut
, makeWrapper
, installShellFiles
, wtype
, wl-clipboard
, pass
, bemenu
}:

stdenvNoCC.mkDerivation rec {
  pname = "tessen";
  version = "unstable-2022-08-04";

  src = fetchFromSourcehut {
    owner = "~ayushnix";
    repo  = pname;
    rev = "8758a09345f6eef24764de4a0efad737f12562c8";
    sha256  = "sha256-U6obXpYzIprOJ+b3QiE+eDOq1s0DYiwM55qTga9/8TE=";
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D tessen $out/bin/tessen
    wrapProgram $out/bin/tessen --prefix PATH : ${ lib.makeBinPath [ bemenu pass wtype wl-clipboard ] }
    runHook postInstall
  '';

  postInstall = ''
    installManPage man/*
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
  };
}
