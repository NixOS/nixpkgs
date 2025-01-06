{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
  python-rapidjson,
  numpy,
  # optional dependencies
  grpcio,
  packaging,
  aiohttp,
  geventhttpclient,
}:

let
  pname = "tritonclient";
  version = "2.35.0";
in
buildPythonPackage {
  inherit pname version;
  format = "wheel";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    python = "py3";
    dist = "py3";
    format = "wheel";
    platform = "manylinux1_x86_64";
    hash = "sha256-JXVr+DWkM2g7CiU9STMcZyQJieXgNbKXlX/jqf/oam8=";
  };

  propagatedBuildInputs = [
    python-rapidjson
    numpy
  ];

  doCheck = false;

  pythonImportsCheck = [ "tritonclient" ];

  passthru = {
    optional-dependencies = {
      http = [
        aiohttp
        geventhttpclient
      ];
      grpc = [
        grpcio
        packaging
      ];
    };
  };

  meta = {
    description = "Triton python client";
    homepage = "https://github.com/triton-inference-server/client";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.linux;
  };
}
