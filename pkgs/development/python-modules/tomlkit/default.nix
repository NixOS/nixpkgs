{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, enum34
, functools32, typing ? null
, pytestCheckHook
, pyaml
}:

buildPythonPackage rec {
  pname = "tomlkit";
  version = "0.11.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MjWpAQ+uVDI+cnw6wG+3IHUv5mNbNCbjedrsYPvUSoM=";
  };

  propagatedBuildInputs =
    lib.optionals isPy27 [ enum34 functools32 ]
    ++ lib.optional isPy27 typing;

  checkInputs = [
    pyaml
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tomlkit" ];

  meta = with lib; {
    homepage = "https://github.com/sdispater/tomlkit";
    description = "Style-preserving TOML library for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
