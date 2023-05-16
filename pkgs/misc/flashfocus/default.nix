<<<<<<< HEAD
{ lib, python3, fetchPypi, netcat-openbsd, nix-update-script }:
=======
{ lib, python3, netcat-openbsd, nix-update-script }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3.pkgs.buildPythonApplication rec {
  pname = "flashfocus";
  version = "2.3.1";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3.pkgs.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "sha256-XT3CKJWn1uKnPPsJC+MWlEAd8sWdVTEXz5b3n0UUedY=";
  };

  postPatch = ''
    substituteInPlace bin/nc_flash_window \
      --replace "nc" "${lib.getExe netcat-openbsd}"
  '';

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "pyyaml"
    "xcffib"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    i3ipc
    xcffib
    click
    cffi
    xpybutil
    marshmallow
    pyyaml
  ];

  # Tests require access to a X session
  doCheck = false;

  pythonImportsCheck = [ "flashfocus" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/fennerm/flashfocus";
    description = "Simple focus animations for tiling window managers";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}
