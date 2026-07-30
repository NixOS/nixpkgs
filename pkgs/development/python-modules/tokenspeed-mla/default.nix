{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  apache-tvm-ffi,
  nvidia-cutlass-dsl,
  tokenspeed-triton,
  torch,
}:
buildPythonPackage (finalAttrs: {
  pname = "tokenspeed-mla";
  version = "0.1.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lightseekorg";
    repo = "tokenspeed";
    rev = "a39b3854dfd9b08a410028dbe5260eda08ef6b63";
    hash = "sha256-rl+cpZabmK24nMcam5Ud4GqnpLA3TqpVRznlX6lz6Xs=";
  };

  sourceRoot = "${finalAttrs.src.name}/tokenspeed-mla";

  build-system = [
    setuptools
  ];

  dependencies = [
    apache-tvm-ffi
    nvidia-cutlass-dsl
    tokenspeed-triton
    torch
  ];

  pythonImportsCheck = [ "tokenspeed_mla" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Speed-of-light TokenSpeed MLA kernels for Blackwell SM100 and SM103";
    homepage = "https://github.com/lightseekorg/tokenspeed/tree/main/tokenspeed-mla";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prince213 ];
    broken = !torch.cudaSupport;
  };
})
