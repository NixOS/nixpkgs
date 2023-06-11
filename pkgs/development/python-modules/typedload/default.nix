{ buildPythonPackage
, fetchPypi
, lib
, setuptools
}:

let
  typedload = buildPythonPackage rec {
    pname = "typedload";
    version = "2.22";
    format = "pyproject";

    src = fetchPypi {
      inherit pname version;
      sha256 = "k1mhAbdwmySxDDqvoxSP9A0VCxtJ+PFGs0m9QDQwywY=";
    };

    meta = with lib; {
      homepage = "https://ltworf.github.io/typedload/";
      description = "Load and dump json-like data into typed data structures";
      license = licenses.gpl3;
      maintainers = with maintainers; [ ppentchev ];
    };

    propagatedBuildInputs = [
      setuptools
    ];

    pythonImportsCheck = [ "typedload" ];
  };
in
typedload
