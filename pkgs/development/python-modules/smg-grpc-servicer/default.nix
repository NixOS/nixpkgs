{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  grpcio,
  grpcio-health-checking,
  grpcio-reflection,
  smg-grpc-proto,
}:
buildPythonPackage (finalAttrs: {
  pname = "smg-grpc-servicer";
  version = "0.5.5";
  pyproject = true;
  __structuredAttrs = true;

  # No tags on GitHub
  src = fetchPypi {
    format = "setuptools";
    pname = "smg_grpc_servicer";
    inherit (finalAttrs) version;
    hash = "sha256-g3SCR/WjoSpxoq1a+Elvf9z+kAvb8nGgayMRMR/q4d8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    grpcio
    grpcio-health-checking
    grpcio-reflection
    smg-grpc-proto
  ];

  postInstall = ''
    find $out -name __pycache__ -type d | xargs rm -rv
  '';

  env.PYTHONDONTWRITEBYTECODE = 1;

  pythonImportsCheck = [ "smg_grpc_servicer" ];

  # no tests
  doCheck = false;

  meta = {
    description = "SMG gRPC servicer implementations for LLM inference engines (vLLM, SGLang, MLX)";
    homepage = "https://github.com/lightseekorg/smg/tree/main/grpc_servicer";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prince213 ];
  };
})
