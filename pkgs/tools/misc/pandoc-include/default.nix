{ buildPythonApplication
, fetchFromGitHub
, lib
, natsort
, panflute
, setuptools
}:

buildPythonApplication rec {
  pname = "pandoc-include";
  version = "1.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "DCsunset";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kuxud7m+sWcNqE8A+Fwb8ATgiUwxQvHeYBTyw1UzX4U=";
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
