{ lib
, stdenv
, python3Packages
, fetchFromGitHub
, makeWrapper
}:

python3Packages.buildPythonApplication rec {
  pname = "nvitop";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "XuehaiPan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nGdEMLxpw2Ts0dypkoZg3r2NF4IeT1ykbRmrmf9qxrA=";
  };

  propagatedBuildInputs = with python3Packages; [
    cachetools
    psutil
    termcolor
    nvidia-ml-py
  ];

  checkPhase = ''
    $out/bin/nvitop --help
  '';

  meta = with lib; {
    description = "An interactive NVIDIA-GPU process viewer, the one-stop solution for GPU process management";
    homepage = "https://github.com/XuehaiPan/nvitop";
    license = licenses.gpl3;
    maintainers = with maintainers; [ GaetanLepage ];
    platforms = with platforms; linux;
  };
}
