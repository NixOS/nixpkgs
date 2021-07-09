{ lib, buildPythonPackage, fetchPypi
, marshmallow
}:

buildPythonPackage rec {
  pname = "webargs";
  version = "5.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16pjzc265yx579ijz5scffyfd1vsmi87fdcgnzaj2by6w2i445l7";
  };

  propagatedBuildInputs = [ marshmallow ];

  # No idea how to run its tests
  doCheck = false;

  pythonImportsCheck = [
    "webargs"
  ];

  meta = with lib; {
    description = "Declarative parsing and validation of HTTP request objects, with built-in support for popular web frameworks";
    homepage = "https://github.com/marshmallow-code/webargs";
    license = licenses.mit;
    maintainers = [ maintainers.viric ];
  };
}
