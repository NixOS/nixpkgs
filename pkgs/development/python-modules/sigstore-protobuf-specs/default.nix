{
  lib,
  pythonOlder,
  flit-core,
  fetchPypi,
  buildPythonPackage,
  betterproto,
}:

buildPythonPackage rec {
  pname = "sigstore-protobuf-specs";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "sigstore_protobuf_specs";
    inherit version;
    hash = "sha256-xAthl1uVeukG6ymlvHBA7AFbaLa0YAXMWAXmKUk+jew=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ betterproto ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sigstore_protobuf_specs" ];

  meta = with lib; {
    description = "Library for serializing and deserializing Sigstore messages";
    homepage = "https://pypi.org/project/sigstore-protobuf-specs/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
