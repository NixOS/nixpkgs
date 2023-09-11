{ lib
, buildPythonPackage
, fetchPypi
, requests
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "serverfiles";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XhD8MudYeR43NbwIvOLtRwKoOx5Fq5bF1ZzIruz76+E=";
  };

  propagatedBuildInputs = [ requests ];

  pythonImportsCheck = [ "serverfiles" ];
  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "An utility that accesses files on a HTTP server and stores them locally for reuse";
    homepage = "https://github.com/biolab/serverfiles";
    license = [ lib.licenses.gpl3Plus ];
    maintainers = [ lib.maintainers.lucasew ];
  };
}
