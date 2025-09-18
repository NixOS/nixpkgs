{
  lib,
  python,
  autoAddDriverRunpath,
  buildPythonPackage,
  autoPatchelfHook,
  unzip,
  cudaPackages,
}:

let
  pyVersion = "${lib.versions.major python.version}${lib.versions.minor python.version}";
  buildVersion = lib.optionalString (cudaPackages ? tensorrt) cudaPackages.tensorrt.version;
in
buildPythonPackage rec {
  pname = "tensorrt";
  version = buildVersion;

  src = cudaPackages.tensorrt.src;

  format = "wheel";
  # We unpack the wheel ourselves because of the odd packaging.
  dontUseWheelUnpack = true;

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
    autoAddDriverRunpath
  ];

  preUnpack = ''
    mkdir -p dist
    tar --strip-components=2 -xf "$src" --directory=dist \
      "TensorRT-${buildVersion}/python/tensorrt-${buildVersion}-cp${pyVersion}-none-linux_x86_64.whl"
  '';

  sourceRoot = ".";

  buildInputs = [
    cudaPackages.cudnn
    cudaPackages.tensorrt
  ];

  pythonImportsCheck = [ "tensorrt" ];

  meta = with lib; {
    description = "Python bindings for TensorRT, a high-performance deep learning interface";
    homepage = "https://developer.nvidia.com/tensorrt";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aidalgol ];
    broken = !(cudaPackages ? tensorrt) || !(cudaPackages ? cudnn);
  };
}
