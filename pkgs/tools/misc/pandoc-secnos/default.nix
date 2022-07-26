{ buildPythonApplication
, fetchFromGitHub
, lib
, pandoc-xnos
}:

buildPythonApplication rec {
  pname = "pandoc-secnos";
  version = "2.2.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tomduck";
    repo = pname;
    rev = version;
    sha256 = "sha256-J9KLZvioYM3Pl2UXjrEgd4PuLTwCLYy9SsJIzgw5/jU=";
  };

  propagatedBuildInputs = [ pandoc-xnos ];

  patches = [
    ./patch/fix-manifest.patch
  ];

  # Different pandoc executables are not available
  doCheck = false;

  meta = with lib; {
    description = "Standalone pandoc filter from the pandoc-xnos suite for numbering sections and section references";
    homepage = "https://github.com/tomduck/pandoc-secnos";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ppenguin ];
  };
}
