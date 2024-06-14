{
  lib,
  python,
  autoAddDriverRunpath,
  buildPythonPackage,
  autoPatchelfHook,
  cudaPackages,
}:

let
  pyVersion = lib.versions.majorMinor python.version;
  version = cudaPackages.utils.majorMinorPatch cudaPackages.tensorrt.version;
in
buildPythonPackage {
  pname = "tensorrt";
  inherit version;

  src = "${cudaPackages.tensorrt.python}/python/tensorrt-${version}-cp${pyVersion}-none-linux_x86_64.whl";

  format = "wheel";

  nativeBuildInputs = [
    autoPatchelfHook
    autoAddDriverRunpath
  ];

  buildInputs = [
    cudaPackages.tensorrt.lib
    # NOTE: Make sure to use the version of CUDNN which satisfies the requirements of TensorRT.
    cudaPackages.tensorrt.passthru.cudnn.lib
  ];

  pythonImportsCheck = [ "tensorrt" ];

  meta = with lib; {
    description = "Python bindings for TensorRT, a high-performance deep learning interface";
    homepage = "https://developer.nvidia.com/tensorrt";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aidalgol ];
    broken = !(cudaPackages ? tensorrt);
  };
}
