{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, typing-extensions
, dataclasses
}:

buildPythonPackage rec {
  version = "0.1.2";
  pname = "simple_di";
  disabled = pythonOlder "3.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wqbfbajnwmkzih0jl3mncalr7dslvmwhb5mk11asqvmbp1xhn30";
  };

  propagatedBuildInputs = [
    setuptools
    typing-extensions
  ] ++ lib.optional (pythonOlder "3.7") [
    dataclasses
  ];

  meta = {
    description = "Simple dependency injection library";
    homepage = "https://github.com/bentoml/simple_di";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sauyon ];
  };
}
