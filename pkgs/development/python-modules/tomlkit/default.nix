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
  version = "0.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YZAfgf9AF5URGc0NHtm3rzHIIdaEXIxHdYe73NXlhU4=";
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
