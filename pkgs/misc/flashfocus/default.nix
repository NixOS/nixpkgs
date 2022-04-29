{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "flashfocus";
  version = "2.2.3";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0cn44hryvz2wl7xklaslxsb3l2i3f8jkgmml0n9v2ks22j5l4r4h";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyyaml>=5.1,<6.0" "pyyaml>=5.1"
  '';

  nativeBuildInputs = with python3.pkgs; [
    pytest-runner
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

  meta = with lib; {
    homepage = "https://github.com/fennerm/flashfocus";
    description = "Simple focus animations for tiling window managers";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}
