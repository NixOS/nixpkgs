{ lib
, buildPythonApplication
, fetchFromGitHub
, setuptools-scm
, setuptools
, vdf
, bash
, steam-run
, winetricks
, yad
, pytestCheckHook
}:

buildPythonApplication rec {
  pname = "protontricks";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Matoking";
    repo = pname;
    rev = version;
    hash = "sha256-sbYIqVsuDZ2Htb6SVIe/gBA1UIvUzu4fjTjWQ7k1WFs=";
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
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [
      bash
      steam-run
      winetricks
      yad
    ]}"
  ];

  checkInputs = [ pytestCheckHook ];

  # From 1.6.0 release notes (https://github.com/Matoking/protontricks/releases/tag/1.6.0):
  # In most cases the script is unnecessary and should be removed as part of the packaging process.
  postInstall = ''
    rm "$out/bin/protontricks-desktop-install"
  '';

  pythonImportsCheck = [ "protontricks" ];

  meta = with lib; {
    description = "A simple wrapper for running Winetricks commands for Proton-enabled games";
    homepage = "https://github.com/Matoking/protontricks";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
