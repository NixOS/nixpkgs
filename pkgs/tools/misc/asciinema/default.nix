{ lib
, python3Packages
, fetchFromGitHub
, glibcLocales
}:

python3Packages.buildPythonApplication rec {
  pname = "asciinema";
<<<<<<< HEAD
  version = "2.3.0";
=======
  version = "2.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "asciinema";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-1B2A2lfLeDHgD4tg3M5IIyHxBQ0cHuWDrQ3bUKAIFlc=";
=======
    hash = "sha256-ioSNd0Fjk2Fp05lk3HeokIjNYGU0jQEaIDfcFB18mV0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    python3Packages.setuptools
  ];

  postPatch = ''
    substituteInPlace tests/pty_test.py \
      --replace "python3" "${python3Packages.python}/bin/python"
  '';

  nativeCheckInputs = [
    glibcLocales
    python3Packages.nose
  ];

  checkPhase = ''
<<<<<<< HEAD
    LC_ALL=en_US.UTF-8 nosetests -v tests/config_test.py
  '';

  meta = {
    description = "Terminal session recorder and the best companion of asciinema.org";
    homepage = "https://asciinema.org/";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ eclairevoyant ];
    platforms = lib.platforms.all;
    mainProgram = pname;
=======
    LC_ALL=en_US.UTF-8 nosetests
  '';

  meta = with lib; {
    description = "Terminal session recorder and the best companion of asciinema.org";
    homepage = "https://asciinema.org/";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
