{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  grpcio-tools,
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "smg-grpc-proto";
  version = "0.4.8";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lightseekorg";
    repo = "smg";
    # https://github.com/lightseekorg/smg/actions/workflows/release-grpc.yml
    rev = "5c875dbc3485a720f4675c886b53cd5a95c26ccc";
    hash = "sha256-VbjHarLWqqlbGnmK4yrlWIdA3xTbfNLPEKhOuOWXAUs=";
  };

  sourceRoot = "${finalAttrs.src.name}/crates/grpc_client/python";

  build-system = [
    grpcio-tools
    setuptools
  ];

  pythonImportsCheck = [
    "smg_grpc_proto"
  ];

  meta = {
    description = "SMG gRPC proto definitions for SGLang, vLLM, TRT-LLM, and MLX";
    homepage = "https://github.com/lightseekorg/smg/tree/main/crates/grpc_client/python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prince213 ];
  };
})
