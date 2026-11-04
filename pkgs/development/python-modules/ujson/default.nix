{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "ujson";
  version = "6.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rvfqTNni6fijXEU4qXgNWMgNdsXaZqja0mm0zG2TDCk=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ujson" ];

  meta = {
    description = "Ultra fast JSON encoder and decoder";
    homepage = "https://github.com/ultrajson/ultrajson";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
