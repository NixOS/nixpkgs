{ stdenv
, lib
, fetchFromGitLab
, runtimeShell
, makeWrapper
}:

stdenv.mkDerivation {
  pname = "dt-shell-color-scripts";
  version = "unstable-2022-02-22";

  src = fetchFromGitLab {
    owner = "dwt1";
    repo = "shell-color-scripts";
    rev = "fcd013ea2e1ff80e01adbcea9d0eaf9c73db94c0";
    sha256 = "sha256-bd3NBf99rCiADUKQb6fzCBDaKBmYaZHcO4qokm/39do=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    patchShebangs ./colorscript.sh
    patchShebangs ./colorscripts
    mkdir -p $out/bin
    mkdir -p $out/opt/shell-color-scripts/
    cp -r colorscripts $out/opt/shell-color-scripts/colorscripts
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
