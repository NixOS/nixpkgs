{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pyopenssl,
}:

buildPythonPackage rec {
  pname = "uonet-request-signer-hebe";
  version = "0.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fidopnpAt5CXPsLbx+V8wrJCQQ/WIO6AqxpsYLDv8qM=";
  };

  propagatedBuildInputs = [ pyopenssl ];

  # Source is not tagged
  doCheck = false;

  pythonImportsCheck = [ "uonet_request_signer_hebe" ];

  meta = with lib; {
    description = "UONET+ (hebe) request signer for Python";
    homepage = "https://github.com/wulkanowy/uonet-request-signer";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
