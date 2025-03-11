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
    "aarch64-linux" = "manylinux_2_17_aarch64.manylinux2014_aarch64";
    "x86_64-linux" = "manylinux_2_17_x86_64.manylinux2014_x86_64";
    "aarch64-darwin" = "macosx_11_0_arm64";
  };
  hashes = {
    "310-x86_64-linux" = "sha256-GmzcxS5LhB0j5Qovoo4Bbm2fYdbqkYjUVV6hibBAoPY=";
    "311-x86_64-linux" = "sha256-NzVYuAPYwsV/xhOxEAeuWBOfGaPN3UQ6DeXXtTIeWWE=";
    "312-x86_64-linux" = "sha256-ztVDC836f8s6a9xEczF2FYy4d7Nb3SM8rILiW0zJTpI=";
    "313-x86_64-linux" = "sha256-UrVG8Hayw78hfGDwXeQSTMEZfOkvjoJufsc64yQHSlo=";
    "310-aarch64-linux" = "sha256-lQQbVaLshtH2aQUS0Yg1gbGPL09Gw9l4lK6wrC22r38=";
    "311-aarch64-linux" = "sha256-ZcOhoqNaG1N0A/NkA9JYyqtHflZLwPZBCblBzHe08gM=";
    "312-aarch64-linux" = "sha256-h6l6NLBHXdx9KvxA5d1/jRJSKqge37zMs5Yoz1kUVNU=";
    "313-aarch64-linux" = "sha256-YnbiebRetdm5XE3z55ViVfQU/UsSjS3hbYrs3obDY1c";
    "310-aarch64-darwin" = "sha256-uWG7u3ocakjkwUBqmMrr60AEYeLnWgi23wwBMpQDehU=";
    "311-aarch64-darwin" = "sha256-9A5zvNwzPfs/f+D88CO8vsQVM8mFZldxj/duzhoZAuA=";
    "312-aarch64-darwin" = "sha256-06JP62GV8cIiFillwBB8n/VtMizKI+GfDmZjb264DxQ=";
    "313-aarch64-darwin" = "sha256-3ohD+zRiiZ3nvN7qzLkjA6nWEAa8NjZN60qI30YyC6Q=";
  };
in
buildPythonPackage rec {
  pname = "tensorstore";
  version = "0.1.71";
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

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

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
