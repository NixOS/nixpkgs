{ buildPythonApplication
, fetchFromGitHub
, lib
, natsort
, panflute
, setuptools
}:

buildPythonApplication rec {
  pname = "pandoc-include";
  version = "1.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "DCsunset";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-BDMg3zxNoVtO4dI1t4Msi1UwH+D8uZjBIezsER5KWHA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ natsort panflute ];

  pythonImportsCheck = [ "pandoc_include.main" ];

  meta = with lib; {
    description = "Pandoc filter to allow file and header includes";
    homepage = "https://github.com/DCsunset/pandoc-include";
    license = licenses.mit;
    maintainers = with maintainers; [ ppenguin ];
    mainProgram = "pandoc-include";
  };
}
