{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "visitor";
  version = "0.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LHN5A7K2hk68YWfu9887mXEm8aqUvfWQ+Q8UNtI+SAo=";
  };

  meta = with lib; {
    homepage = "https://github.com/mbr/visitor";
    description = "Tiny pythonic visitor implementation";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
