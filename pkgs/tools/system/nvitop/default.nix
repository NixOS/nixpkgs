{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "nvitop";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "XuehaiPan";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Za2NJ4gx+aE/cfl2wzbwLxIFNL1UzgKVbb6VqopkNxs=";
  };

  pythonRelaxDeps = [ "nvidia-ml-py" ];

  nativeBuildInputs = with python3Packages; [ pythonRelaxDepsHook ];

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
