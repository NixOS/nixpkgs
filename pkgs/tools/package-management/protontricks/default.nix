{ lib
, buildPythonApplication
, fetchFromGitHub
, setuptools_scm
, vdf
, steam-run
, winetricks
, zenity
, pytestCheckHook
}:

buildPythonApplication rec {
  pname = "protontricks";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "Matoking";
    repo = pname;
    rev = version;
    sha256 = "0ri4phi1rna9snrxa6gl23walyack09mgax7zpjqfpxivwls3ach";
  };

  patches = [
    # Use steam-run to run Proton binaries
    ./steam-run.patch
  ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
  '';

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ vdf ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [
      steam-run
      winetricks
      zenity
    ]}"
  ];

  checkInputs = [ pytestCheckHook ];
  disabledTests = [
    # Steam runtime is hard-coded with steam-run.patch and can't be configured
    "test_run_steam_runtime_not_found"
  ];

  meta = with lib; {
    description = "A simple wrapper for running Winetricks commands for Proton-enabled games";
    homepage = "https://github.com/Matoking/protontricks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ metadark ];
    platforms = platforms.linux;
  };
}
