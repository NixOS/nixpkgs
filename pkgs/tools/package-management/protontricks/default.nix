{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  replaceVars,
  writeShellScript,
  steam-run,
  fetchpatch2,
  setuptools-scm,
  setuptools,
  vdf,
  pillow,
  winetricks,
  yad,
  pytestCheckHook,
  nix-update-script,
  extraCompatPaths ? "",
}:

buildPythonApplication rec {
  pname = "protontricks";
  version = "1.12.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Matoking";
    repo = "protontricks";
    tag = version;
    hash = "sha256-xNy7quksnZ6BnZk5Rz9kwwoC4xitmfnSe5Zj6gZO8S4=";
  };

  patches = [
    # Use steam-run to run Proton binaries
    (replaceVars ./steam-run.patch {
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
  ];

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    setuptools # implicit dependency, used to find data/icon_placeholder.png
    vdf
    pillow
  ];

  makeWrapperArgs =
    [
      "--prefix PATH : ${
        lib.makeBinPath [
          winetricks
          yad
        ]
      }"
      # Steam Runtime does not work outside of steam-run, so don't use it
      "--set STEAM_RUNTIME 0"
    ]
    ++ lib.optional (extraCompatPaths != "") "--set STEAM_EXTRA_COMPAT_TOOLS_PATHS ${extraCompatPaths}";

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
    changelog = "https://github.com/Matoking/protontricks/blob/${src.tag}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
