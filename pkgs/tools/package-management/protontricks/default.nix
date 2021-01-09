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
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "Matoking";
    repo = pname;
    rev = version;
    sha256 = "0a5727igwafwvj8rr5lv0lx8rlfji3qkzmrbp0d15w5dc4fhknp0";
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
      (winetricks.override {
        # Remove default build of wine to reduce closure size.
        # Falls back to wine in PATH when --no-runtime is passed.
        wine = null;
      })
      zenity
    ]}"
  ];

  checkInputs = [ pytestCheckHook ];
  disabledTests = [
    # Steam runtime is hard-coded with steam-run.patch and can't be configured
    "test_run_steam_runtime_not_found"
    "test_unknown_steam_runtime_detected"

    # Steam runtime 2 currently isn't supported
    # See https://github.com/NixOS/nixpkgs/issues/100655
    "test_run_winetricks_steam_runtime_v2"
  ];

  meta = with lib; {
    description = "A simple wrapper for running Winetricks commands for Proton-enabled games";
    homepage = "https://github.com/Matoking/protontricks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ metadark ];
    platforms = platforms.linux;
  };
}
