{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "pandoc-eqnos";
  version = "2.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tomduck";
    repo = pname;
    rev = version;
    sha256 = "sha256-7GQdfGHhtQs6LZK+ZyMmcPSkoFfBWmATTMejMiFcS7Y=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [ pandoc-xnos ];

  # Different pandoc executables are not available
  doCheck = false;

  meta = with lib; {
    description = "Standalone pandoc filter from the pandoc-xnos suite for numbering equations and equation references";
    homepage = "https://github.com/tomduck/pandoc-eqnos";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ppenguin ];
    mainProgram = "pandoc-eqnos";
  };
}
