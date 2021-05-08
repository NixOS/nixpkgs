{ lib
, stdenv
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
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fde1dd27052ab5e5693e1fbe3ba091a6496daf1125409d73232561145fca369";
  };

  checkInputs = [
    pyopenssl
    service-identity
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    cryptography
    idna
  ] ++ lib.optionals (!isPy3k) [
    futures
  ];

  # aarch64-darwin forbids W+X memory, but this tests depends on it:
  # * https://github.com/pyca/pyopenssl/issues/873
  disabledTests = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    "test_pyopenssl_end_to_end"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "High quality TLS certs while you wait, for the discerning tester";
    homepage = "https://github.com/python-trio/trustme";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
