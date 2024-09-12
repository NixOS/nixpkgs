{
  autoPatchelfHook,
  buildPythonPackage,
  fetchPypi,
  lib,
  ml-dtypes,
  numpy,
  python,
  stdenv,
}:

let
  pythonVersionNoDot = builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  systemToPlatform = {
    "x86_64-linux" = "manylinux_2_17_x86_64.manylinux2014_x86_64";
    "aarch64-darwin" = "macosx_11_0_arm64";
  };
  hashes = {
    "310-x86_64-linux" = "sha256-oB68FjYzmRARWpbajQuLpAzWwg9CCji4tLZRFCsztjk=";
    "311-x86_64-linux" = "sha256-kGEecBu7b3TFGUIRirI9q2W3nipiQwsh/1OB92RqDB4=";
    "312-x86_64-linux" = "sha256-Vw8sT5kahSN20BQs3MOYesSUZqk4CuvfZR1z5nAO7g8=";
    "310-aarch64-darwin" = "sha256-2vuVxmJMx/GeaHgzUS6rRdysQFHreVzZ5IT5YSDUJro=";
    "311-aarch64-darwin" = "sha256-0xRVDSDE9upz2yU7mzpa3Y6l6M5FWOMAPKWBC8eY3Eo=";
    "312-aarch64-darwin" = "sha256-i2TmLOl2aHD5iyzF6YpjbHKFmBGPx5ixPYyNKKQfRNM=";
  };
in
buildPythonPackage rec {
  pname = "tensorstore";
  version = "0.1.65";
  format = "wheel";

  # The source build involves some wonky Bazel stuff.
  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "cp${pythonVersionNoDot}";
    abi = "cp${pythonVersionNoDot}";
    dist = "cp${pythonVersionNoDot}";
    platform = systemToPlatform.${stdenv.system} or (throw "unsupported system");
    hash =
      hashes."${pythonVersionNoDot}-${stdenv.system}"
        or (throw "unsupported system/python version combination");
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  dependencies = [
    ml-dtypes
    numpy
  ];

  pythonImportsCheck = [ "tensorstore" ];

  meta = {
    description = "Library for reading and writing large multi-dimensional arrays";
    homepage = "https://google.github.io/tensorstore";
    changelog = "https://github.com/google/tensorstore/releases/tag/v${version}";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ samuela ];
  };
}
