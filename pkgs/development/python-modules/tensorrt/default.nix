{
  autoPatchelfHook,
  buildPythonPackage,
  cudaPackages,
  lib,
  python,
  stdenv,
}:
let
  inherit (cudaPackages.tensorrt)
    meta
    pname
    src
    version
    ;
  inherit (lib.versions) major minor;
  inherit (stdenv.hostPlatform) parsed;
in
buildPythonPackage {
  # Make sure to add the cudaNamePrefix tag since we're not using cudaPackages.buildRedist but this is a
  # redistributable.
  pname = "${cudaPackages.cudaNamePrefix}-${pname}";

  inherit version;

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
    cudaPackages.tensorrt
  ];

  pythonImportsCheck = [ "tensorrt" ];

  meta = {
    description = "Python bindings for TensorRT, a high-performance deep learning interface";

    # Explicitly inherit from TensorRT's meta to avoid pulling in attributes added by stdenv.mkDerivation.
    inherit (meta)
      badPlatforms
      broken
      changelog
      downloadPage
      homepage
      license
      longDescription
      maintainers
      platforms
      sourceProvenance
      teams
      ;
  };
}
