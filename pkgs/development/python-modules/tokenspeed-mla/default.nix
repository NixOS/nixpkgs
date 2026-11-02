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
  version = "0.2.10";
  pyproject = true;
  __structuredAttrs = true;

  # No git tags. Using the commits named 'Update tokenspeed-mla to XXX'
  src = fetchFromGitHub {
    owner = "lightseekorg";
    repo = "tokenspeed";
    rev = "bf2e923bb422bbc3777fec11ad6b388d2576fde1";
    hash = "sha256-UmcM+lALQoTbbbbp4D3woo5vsNICbY9m/MS3wjdyJeE=";
  };

  sourceRoot = "${finalAttrs.src.name}/tokenspeed-mla";

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "apache-tvm-ffi"
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
