{ lib, python3Packages, fetchPypi, netcat-openbsd, nix-update-script }:

python3Packages.buildPythonApplication rec {
  pname = "flashfocus";
  version = "2.4.0";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TKqPUJq3t2EjX6sY3NSuW0sCq4IS4PNMaaFNe+5hvoY=";
  };

  postPatch = ''
    substituteInPlace bin/nc_flash_window \
      --replace "nc" "${lib.getExe netcat-openbsd}"
  '';

  nativeBuildInputs = with python3Packages; [
    pythonRelaxDepsHook
    setuptools
  ];

  pythonRelaxDeps = [
    "pyyaml"
    "xcffib"
  ];

  propagatedBuildInputs = with python3Packages; [
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
