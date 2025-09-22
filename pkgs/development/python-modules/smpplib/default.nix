{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  six,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "smpplib";
  version = "2.2.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
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

  meta = with lib; {
    description = "SMPP library for Python";
    homepage = "https://github.com/python-smpplib/python-smpplib";
    changelog = "https://github.com/python-smpplib/python-smpplib/releases/tag/${version}";
    license = licenses.lgpl3Plus;
    maintainers = [ ];
  };
}
