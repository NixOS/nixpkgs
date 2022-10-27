{ stdenv
, lib
, fetchFromGitLab
, installShellFiles
, runtimeShell
, makeWrapper
}:

stdenv.mkDerivation {
  pname = "dt-shell-color-scripts";
  version = "unstable-2022-07-25";

  src = fetchFromGitLab {
    owner = "dwt1";
    repo = "shell-color-scripts";
    rev = "da2e3c512b94f312ee54a38d5cde131b0511ad01";
    sha256 = "sha256-cdTgBbtsbJHaJuLIcZh0g0jKOrQyFx3P6QhYNx8hz0U=";
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  installPhase = ''
    runHook preInstall
    patchShebangs ./colorscript.sh
    patchShebangs ./colorscripts
    mkdir -p $out/bin
    mkdir -p $out/opt/shell-color-scripts/
    cp -r colorscripts $out/opt/shell-color-scripts/colorscripts
    installManPage colorscript.1
    installShellCompletion --fish completions/colorscript.fish
    installShellCompletion --zsh completions/_colorscript
    chmod +x colorscript.sh
    cp colorscript.sh $out/bin/colorscript
    substituteInPlace $out/bin/colorscript \
      --replace "/opt/shell-color-scripts/colorscripts" "$out/opt/shell-color-scripts/colorscripts"
    runHook postInstall
  '';

    meta = with lib; {
      description = "A collection of shell color scripts collected by dt (Derek Taylor)";
      homepage = "https://gitlab.com/dwt1/shell-color-scripts";
      license = with licenses; [ mit ];
      maintainers = with maintainers; [ drzoidberg ];
    };
}
