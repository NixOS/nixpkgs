{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  stdenv,

  # nativeBuildInputs
  autoPatchelfHook,
  pypaInstallHook,
  pythonRuntimeDepsCheckHook,
  wheelUnpackHook,

  # dependencies
  apache-tvm-ffi,
  nvidia-cutlass-dsl,
  nvidia-cutlass-dsl-libs-base,
  tokenspeed-triton,
  torch,
}:
let
  inherit (stdenv.hostPlatform) system;

  hashes = {
    aarch64-linux = "sha256-rD4rFrvtQXuICjBOkFfmzj3DaGRC4RHGX5EV4x/3T34=";
    x86_64-linux = "sha256-1gW6k7nZT4Luj1LOLWaAs91AHBmPi0XCL11loqaCHqQ=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "tokenspeed-mla";
  version = "0.1.5";
  pyproject = false;
  __structuredAttrs = true;

  src = fetchPypi {
    format = "wheel";
    pname = "tokenspeed_mla";
    inherit (finalAttrs) version;
    dist = "py3";
    python = "py3";
    abi = "none";
    platform = "manylinux_2_28_${stdenv.hostPlatform.uname.processor}";
    hash = hashes.${system} or (throw "Unsupported system: ${system}");
  };

  nativeBuildInputs = [
    autoPatchelfHook
    pypaInstallHook
    pythonRuntimeDepsCheckHook
    wheelUnpackHook
  ];

  dependencies = [
    apache-tvm-ffi
    nvidia-cutlass-dsl
    tokenspeed-triton
    torch
  ];

  preFixup = ''
    # libtvm_ffi.so
    addAutoPatchelfSearchPath "${apache-tvm-ffi}/${python.sitePackages}/tvm_ffi/lib"
    # libcute_dsl_runtime.so
    addAutoPatchelfSearchPath "${nvidia-cutlass-dsl-libs-base}/${python.sitePackages}/nvidia_cutlass_dsl/lib"
  '';

  pythonImportsCheck = [ "tokenspeed_mla" ];

  meta = {
    description = "Speed-of-light TokenSpeed MLA kernels for Blackwell SM100 and SM103";
    homepage = "https://github.com/lightseekorg/tokenspeed/tree/main/tokenspeed-mla";
    downloadPage = "https://pypi.org/project/tokenspeed-mla/#files";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ prince213 ];
    platforms = lib.attrNames hashes;
    broken = !torch.cudaSupport;
  };
})
