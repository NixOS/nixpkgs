{
  lib,
  flit-core,
  fetchPypi,
  buildPythonPackage,
  betterproto,
  pydantic,
}:

buildPythonPackage rec {
  pname = "sigstore-protobuf-specs";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "sigstore_protobuf_specs";
    inherit version;
    hash = "sha256-zvnrMrLGwlHeNuIoWkCq8glIJ+rhifXngE10jMw9W4E=";
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

  meta = {
    description = "Library for serializing and deserializing Sigstore messages";
    homepage = "https://github.com/sigstore/protobuf-specs/tree/main/gen/pb-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
