{ lib
, buildPythonApplication
, fetchFromGitHub
, setuptools-scm
, vdf
, bash
, steam-run
, winetricks
, zenity
, pytestCheckHook
}:

buildPythonApplication rec {
  pname = "protontricks";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "Matoking";
    repo = pname;
    rev = version;
    hash = "sha256-Vmxb8SjPhcSqFzykHRPsLtAoSwomN+se+icwHkucbX8=";
  };

  patches = [
    # Use steam-run to run Proton binaries
    ./steam-run.patch
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;
  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ vdf ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [
      bash
      steam-run
      (winetricks.override {
        # Remove default build of wine to reduce closure size.
        # Falls back to wine in PATH when --no-runtime is passed.
        wine = null;
      })
      zenity
    ]}"
  ];

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "protontricks" ];

  meta = with lib; {
    description = "A simple wrapper for running Winetricks commands for Proton-enabled games";
    homepage = "https://github.com/Matoking/protontricks";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.linux;
  };
}
