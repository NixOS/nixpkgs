{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, hatchling
}:

buildPythonPackage rec {
  pname = "traitlets";
  version = "5.9.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9s3iGpxoz3Vq8CA19y1acjv2B+hi574z7OUFq/Sjutk=";
  };

  nativeBuildInputs = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Traitlets Python config system";
    homepage = "https://github.com/ipython/traitlets";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
