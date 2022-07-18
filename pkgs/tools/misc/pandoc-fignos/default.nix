{ buildPythonApplication
, fetchFromGitHub
, lib
, pandoc-xnos
}:

buildPythonApplication rec {
  pname = "pandoc-fignos";
  version = "2.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tomduck";
    repo = pname;
    rev = version;
    sha256 = "sha256-eDwAW0nLB4YqrWT3Ajt9bmX1A43wl+tOPm2St5VpCLk=";
  };

  propagatedBuildInputs = [ pandoc-xnos ];

  # Different pandoc executables are not available
  doCheck = false;

  meta = with lib; {
    description = "Standalone pandoc filter from the pandoc-xnos suite for numbering figures and figure references";
    homepage = "https://github.com/tomduck/pandoc-fignos";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ppenguin ];
  };
}
