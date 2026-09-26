{
  lib,
  buildPythonPackage,
  fetchPypi,

  # dependencies
  apache-tvm-ffi,
  nvidia-cutlass-dsl,
  tokenspeed-triton,
  torch,
}:
buildPythonPackage (finalAttrs: {
  pname = "tokenspeed-mla";
  version = "0.2.10";
  format = "wheel";
  __structuredAttrs = true;

  src = fetchPypi {
    format = "wheel";
    pname = "tokenspeed_mla";
    inherit (finalAttrs) version;
    dist = "py3";
    python = "py3";
    hash = "sha256-o5dwtxhoLiNVF0O2iizjb1FArCNR/oZBI0PMS0KqV9E=";
  };

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

  meta = {
    description = "Speed-of-light TokenSpeed MLA kernels for Blackwell SM100 and SM103";
    homepage = "https://github.com/lightseekorg/tokenspeed/tree/main/tokenspeed-mla";
    downloadPage = "https://pypi.org/project/tokenspeed-mla/#files";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prince213 ];
    broken = !torch.cudaSupport;
  };
})
