{
  lib,
  pythonOlder,
  flit-core,
  fetchPypi,
  buildPythonPackage,
  betterproto,
  pydantic,
}:

buildPythonPackage rec {
  pname = "sigstore-protobuf-specs";
  version = "0.3.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "sigstore_protobuf_specs";
    inherit version;
    hash = "sha256-yuBBtAUCYAuKYz9DwldpXQIiqU76HlEQp+x62njDnZk=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    betterproto
    pydantic
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sigstore_protobuf_specs" ];

  passthru.skipBulkUpdate = true;

  meta = with lib; {
    description = "Library for serializing and deserializing Sigstore messages";
    homepage = "https://pypi.org/project/sigstore-protobuf-specs/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
