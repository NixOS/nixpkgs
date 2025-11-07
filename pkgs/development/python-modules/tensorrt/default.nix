{
  autoPatchelfHook,
  buildPythonPackage,
  cudaPackages,
  lib,
  python,
  stdenv,
}:
let
  inherit (cudaPackages.tensorrt) src pname version;
  inherit (lib.versions) major minor;
  inherit (stdenv.hostPlatform) parsed;
in
buildPythonPackage {
  inherit pname version;

  src =
    let
      # https://peps.python.org/pep-0427/#file-name-convention
      distribution = pname;
      pythonTag = "cp${major python.version}${minor python.version}";
      abiTag = "none";
      platformTag = "${parsed.kernel.name}_${parsed.cpu.name}";
    in
    src + "/python/${distribution}-${version}-${pythonTag}-${abiTag}-${platformTag}.whl";

  format = "wheel";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

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
    broken = !(cudaPackages ? tensorrt) || !(cudaPackages ? cudnn);
  };
}
