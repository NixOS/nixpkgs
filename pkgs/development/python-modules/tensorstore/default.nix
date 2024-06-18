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
    "310-x86_64-linux" = "sha256-1b6w9wgT6fffTTpJ3MxdPSrFD7Xaby6prQYFljVn4x4=";
    "311-x86_64-linux" = "sha256-8+HlzaxH30gB5N+ZKR0Oq+yswhq5gjiSF9jVsg8U22E=";
    "312-x86_64-linux" = "sha256-e8iEQzB4D3RSXgrcPC4me/vsFKoXf1QFNZfQ7968zQE=";
    "310-aarch64-darwin" = "sha256-2C60yJk/Pbx2woV7hzEmWGzNKWWnySDfTPm247PWIRA=";
    "311-aarch64-darwin" = "sha256-rdLB7l/8ZYjV589qKtORiyu1rC7W30wzrsz1uihNRpk=";
    "312-aarch64-darwin" = "sha256-DpbYMIbqceQeiL7PYwnvn9jLtv8EmfHXmxvPfZCw914=";
  };
in
buildPythonPackage rec {
  pname = "tensorstore";
  version = "0.1.53";
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

  propagatedBuildInputs = [
    ml-dtypes
    numpy
  ];

  pythonImportsCheck = [ "tensorstore" ];

  meta = with lib; {
    description = "Library for reading and writing large multi-dimensional arrays";
    homepage = "https://google.github.io/tensorstore";
    changelog = "https://github.com/google/tensorstore/releases/tag/v${version}";
    license = licenses.asl20;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    maintainers = with maintainers; [ samuela ];
  };
}
