{ lib
, buildPythonPackage
, fetchPypi
, python
, six
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "smpplib";
  version = "2.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8hkec7JNupTyiJvy6hpgru9r1Dr9Pdu8Yy1+QdnzDkc=";
  };

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  postInstall = ''
    rm -rf $out/${python.sitePackages}/tests
  '';

  pythonImportsCheck = [
    "smpplib"
  ];

  meta = with lib; {
    description = "SMPP library for Python";
    homepage = "https://github.com/python-smpplib/python-smpplib";
    changelog = "https://github.com/python-smpplib/python-smpplib/releases/tag/${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ globin ];
  };
}
