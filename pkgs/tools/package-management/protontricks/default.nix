{ lib
, buildPythonApplication
, fetchFromGitHub
, setuptools-scm
, setuptools
, vdf
, pillow
, substituteAll
, writeShellScript
, steam-run
, winetricks
, yad
, pytestCheckHook
, nix-update-script
, extraCompatPaths ? ""
}:

buildPythonApplication rec {
  pname = "protontricks";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "Matoking";
    repo = pname;
    rev = version;
    sha256 = "sha256-a40IAFrzQ0mogMoXKb+Lp0fPc1glYophqtftigk3nAc=";
  };

  patches = [
    # Use steam-run to run Proton binaries
    (substituteAll {
      src = ./steam-run.patch;
      steamRun = lib.getExe steam-run;
      bash = writeShellScript "steam-run-bash" ''
        exec ${lib.getExe steam-run} bash "$@"
      '';
    })
  ];

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    setuptools # implicit dependency, used to find data/icon_placeholder.png
    vdf
    pillow
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [
      winetricks
      yad
    ]}"
    # Steam Runtime does not work outside of steam-run, so don't use it
    "--set STEAM_RUNTIME 0"
  ] ++ lib.optional (extraCompatPaths != "") "--set STEAM_EXTRA_COMPAT_TOOLS_PATHS ${extraCompatPaths}";

  nativeCheckInputs = [ pytestCheckHook ];

  # From 1.6.0 release notes (https://github.com/Matoking/protontricks/releases/tag/1.6.0):
  # In most cases the script is unnecessary and should be removed as part of the packaging process.
  postInstall = ''
    rm "$out/bin/protontricks-desktop-install"
  '';

  pythonImportsCheck = [ "protontricks" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Simple wrapper for running Winetricks commands for Proton-enabled games";
    homepage = "https://github.com/Matoking/protontricks";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
