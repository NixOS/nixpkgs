{ lib
, buildPythonPackage
, fetchPypi
, nose2
, setuptools
}:

buildPythonPackage rec {
  pname = "setuptools_dso";
  version = "2.10";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sjAZ9enOw3vF3zqXNbhu45SM5/sv2kIwfKC6SWJdG0Q=";
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
    maintainers = with maintainers; [ marius851000 xfix ];
  };
}
