{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "pandoc-tablenos";
  version = "2.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tomduck";
    repo = pname;
    rev = version;
    sha256 = "sha256-FwzsRziY3PoySo9hIFuLw6tOO9oQij6oQEyoY8HgnII=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [ pandoc-xnos ];

  # Different pandoc executables are not available
  doCheck = false;

  meta = with lib; {
    description = "Standalone pandoc filter from the pandoc-xnos suite for numbering tables and table references";
    homepage = "https://github.com/tomduck/pandoc-tablenos";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ppenguin ];
    mainProgram = "pandoc-tablenos";
  };
}
