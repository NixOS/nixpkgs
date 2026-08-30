{
  lib,
  buildPythonPackage,
  fetchPypi,
  fastdiff,
  six,
  termcolor,
  pytestCheckHook,
  pytest-cov-stub,
  django,
}:

buildPythonPackage rec {
  pname = "snapshottest";
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u8r4HZLY4zAELlySjhPZ8DXpnpGzFP5V/alJwvF7ZTw=";
  };

  propagatedBuildInputs = [
    fastdiff
    six
    termcolor
  ];

  nativeCheckInputs = [
    django
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "snapshottest" ];

  meta = {
    description = "Snapshot testing for pytest, unittest, Django, and Nose";
    homepage = "https://github.com/syrusakbary/snapshottest";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
