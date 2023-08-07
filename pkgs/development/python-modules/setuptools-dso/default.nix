{ lib
, buildPythonPackage
, fetchFromGitHub
, nose2
, setuptools
}:

buildPythonPackage rec {
  pname = "setuptools-dso";
  version = "2.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mdavidsaver";
    repo = "setuptools_dso";
    rev = version;
    hash = "sha256-/OyPoe75EX2EqUjnVeACaq4NbY8G3tpG+IGP9KbBmIk=";
  };

  propagatedBuildInputs = [ setuptools ];

  nativeCheckInputs = [ nose2 ];

  checkPhase = ''
    runHook preCheck
    nose2 -v
    runHook postCheck
  '';

  meta = with lib; {
    description = "setuptools extension for building non-Python Dynamic Shared Objects";
    homepage = "https://github.com/mdavidsaver/setuptools_dso";
    license = licenses.bsd3;
    maintainers = with maintainers; [ xfix ];
  };
}
