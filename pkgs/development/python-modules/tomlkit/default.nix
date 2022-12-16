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
  version = "0.11.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cblS5XIWiJN/sCz501TbzweFBmFJ0oVeRFMevdK2XXM=";
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
    changelog = "https://github.com/sdispater/tomlkit/blob/${version}/CHANGELOG.md";
    description = "Style-preserving TOML library for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
