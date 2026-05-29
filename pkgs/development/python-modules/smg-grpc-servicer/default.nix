{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  grpcio,
  grpcio-health-checking,
  grpcio-reflection,
  mlx,
  mlx-lm,
  setuptools,
  smg-grpc-proto,
  vllm,
}:
buildPythonPackage (finalAttrs: {
  pname = "smg-grpc-servicer";
  version = "0.5.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lightseekorg";
    repo = "smg";
    # https://github.com/lightseekorg/smg/actions/workflows/release-grpc.yml
    rev = "c5d7afd94c31fa0c0ae33d464a50bff349246869";
    hash = "sha256-MIJCnqYXI3VQrPWtwRRrgdhgzUw503E4iQjDsyDGDHc=";
  };

  sourceRoot = "${finalAttrs.src.name}/grpc_servicer";

  build-system = [
    setuptools
  ];

  dependencies = [
    grpcio
    grpcio-health-checking
    grpcio-reflection
    smg-grpc-proto
  ];

  optional-dependencies = {
    mlx = [
      mlx
      mlx-lm
      smg-grpc-proto
    ];
    sglang = [
      # sglang
    ];
    vllm = [
      vllm
    ];
  };

  pythonImportsCheck = [ "smg_grpc_servicer" ];

  meta = {
    description = "SMG gRPC servicer implementations for LLM inference engines (vLLM, SGLang, MLX)";
    homepage = "https://github.com/lightseekorg/smg/tree/main/grpc_servicer";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prince213 ];
  };
})
