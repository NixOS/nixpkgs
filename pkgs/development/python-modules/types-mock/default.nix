{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-mock";
  version = "5.1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3kjTdm5OMDTv2LJtqeCeSQjzHlMTel/i778fur7haZY=";
  };

  meta = {
    description = "This is a PEP 561 type stub package for the mock package. It can be used by type-checking tools like mypy, pyright, pytype, PyCharm, etc. to check code that uses mock.";
    homepage = "https://pypi.org/project/types-mock";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
