{ lib
, buildPythonApplication
, fetchFromGitHub
, pillow
, setuptools-scm
, setuptools
, vdf
, bash
, steam-run
, winetricks
, yad
, pytestCheckHook
, nix-update-script
}:

buildPythonApplication rec {
  pname = "protontricks";
  version = "1.10.5";

  src = fetchFromGitHub {
    owner = "Matoking";
    repo = pname;
    rev = version;
    hash = "sha256-N9AUpHDJWhUCxXffcfNdW1TtYXMNh/Jh5kAcHovZ6iQ=";
  };

  patches = [
    # Use steam-run to run Proton binaries
    ./steam-run.patch
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    setuptools # implicit dependency, used to find data/icon_placeholder.png
    vdf
    pillow
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [
      bash
      steam-run
      winetricks
      yad
    ]}"
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
