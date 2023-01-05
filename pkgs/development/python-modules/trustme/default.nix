{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, cryptography
, futures ? null
, pyopenssl
, service-identity
, pytestCheckHook
, idna
}:

buildPythonPackage rec {
  pname = "trustme";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XgeyPXDO7WTzuzauS5q8UjVMFsmNRasDe+4rX7/+WGw=";
  };

  checkInputs = [
    pyopenssl
    pytestCheckHook
    service-identity
  ];

  propagatedBuildInputs = [
    cryptography
    idna
  ] ++ lib.optionals (!isPy3k) [
    futures
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "trustme" ];

  meta = with lib; {
    description = "High quality TLS certs while you wait, for the discerning tester";
    homepage = "https://github.com/python-trio/trustme";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ catern ];
  };
}
