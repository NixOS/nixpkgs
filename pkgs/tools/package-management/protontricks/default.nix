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
, fetchpatch2
, winetricks
, yad
, pytestCheckHook
, nix-update-script
}:

buildPythonApplication rec {
  pname = "protontricks";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "Matoking";
    repo = "protontricks";
    rev = "refs/tags/${version}";
    hash = "sha256-dCb8mcwXoxD4abJjLEwk5tGp65XkvepmOX+Kc9Dl7fQ=";
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

    # Revert vendored vdf since our vdf includes `appinfo.vdf` v29 support
    (fetchpatch2 {
      url = "https://github.com/Matoking/protontricks/commit/4198b7ea82369a91e3084d6e185f9b370f78eaec.patch";
      revert = true;
      hash = "sha256-1U/LiAliKtk3ygbIBsmoavXN0RSykiiegtml+bO8CnI=";
    })

    # Fix test_run_no_args test
    (fetchpatch2 {
      url = "https://github.com/Matoking/protontricks/commit/ff2381ad379a612e73f0d4604f1c9c3a012b3355.patch";
      hash = "sha256-aiafLbiqS6TBBiQpfTYPVqhQs2OXYg/4yCtbuTv6Ug8=";
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
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # From 1.6.0 release notes (https://github.com/Matoking/protontricks/releases/tag/1.6.0):
  # In most cases the script is unnecessary and should be removed as part of the packaging process.
  postInstall = ''
    rm "$out/bin/protontricks-desktop-install"
  '';

  pythonImportsCheck = [ "protontricks" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A simple wrapper for running Winetricks commands for Proton-enabled games";
    homepage = "https://github.com/Matoking/protontricks";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
