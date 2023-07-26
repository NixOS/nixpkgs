{ lib
, python3Packages
, fetchFromGitHub
, glibcLocales
}:

python3Packages.buildPythonApplication rec {
  pname = "asciinema";
  version = "2.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "asciinema";
    rev = "v${version}";
    hash = "sha256-1B2A2lfLeDHgD4tg3M5IIyHxBQ0cHuWDrQ3bUKAIFlc=";
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
    LC_ALL=en_US.UTF-8 nosetests -v tests/config_test.py
  '';

  meta = {
    description = "Terminal session recorder and the best companion of asciinema.org";
    homepage = "https://asciinema.org/";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ eclairevoyant ];
    platforms = lib.platforms.all;
    mainProgram = pname;
  };
}
