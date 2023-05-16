{ lib
<<<<<<< HEAD
, python3Packages
, fetchFromGitHub
=======
, stdenv
, python3Packages
, fetchFromGitHub
, makeWrapper
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3Packages.buildPythonApplication rec {
  pname = "nvitop";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "XuehaiPan";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-nHJ2m5Q0IWl0nx13iGBkHsHj2YdPS+33kLUBsjbpyuM=";
  };

  pythonRelaxDeps = [ "nvidia-ml-py" ];

  nativeBuildInputs = with python3Packages; [ pythonRelaxDepsHook ];

=======
    sha256 = "sha256-GcwPFPE9opGMvdeIUg0Pj6qkk0qPU8MNnFTq9qIxFFs=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
