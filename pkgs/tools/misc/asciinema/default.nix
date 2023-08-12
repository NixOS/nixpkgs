{ lib
, python3Packages
, fetchFromGitHub
, glibcLocales
}:

python3Packages.buildPythonApplication rec {
  pname = "asciinema";
  version = "2.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "asciinema";
    rev = "v${version}";
    hash = "sha256-ioSNd0Fjk2Fp05lk3HeokIjNYGU0jQEaIDfcFB18mV0=";
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
    LC_ALL=en_US.UTF-8 nosetests
  '';

  meta = with lib; {
    description = "Terminal session recorder and the best companion of asciinema.org";
    homepage = "https://asciinema.org/";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ ];
  };
}
