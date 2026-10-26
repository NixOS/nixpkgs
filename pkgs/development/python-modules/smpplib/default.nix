{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  six,
  mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "smpplib";
  version = "2.2.4";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-bzsDb8smQ8G3oyibtaxMmnIK8b9z5XLicp22tdgAwnM=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  postInstall = ''
    rm -rf $out/${python.sitePackages}/tests
  '';

  pythonImportsCheck = [ "smpplib" ];

  meta = {
    description = "SMPP library for Python";
    homepage = "https://github.com/python-smpplib/python-smpplib";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
  };
})
