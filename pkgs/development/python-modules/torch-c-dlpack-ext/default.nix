{
  lib,
  buildPythonPackage,
  apache-tvm-ffi,

  # build-system
  setuptools,

  # dependencies
  torch,
}:

buildPythonPackage (finalAttrs: {
  pname = "torch-c-dlpack-ext";
  inherit (apache-tvm-ffi) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/addons/torch_c_dlpack_ext";

  build-system = [
    apache-tvm-ffi
    setuptools
  ];

  dependencies = [
    torch
  ];

  pythonImportsCheck = [ "torch_c_dlpack_ext" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Ahead-Of-Time (AOT) compiled module to support faster DLPack conversion in DLPack";
    homepage = "https://github.com/apache/tvm-ffi/tree/main/addons/torch_c_dlpack_ext";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
