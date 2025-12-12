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
    "aarch64-linux" = "manylinux_2_27_aarch64.manylinux_2_28_aarch64";
    "x86_64-linux" = "manylinux_2_27_x86_64.manylinux_2_28_x86_64";
    "aarch64-darwin" = "macosx_11_0_arm64";
  };
  hashes = {
    "311-x86_64-linux" = "sha256-gwcu4OVR1tylguFUtkyLgGbSduwHWXhOMUnCghKmHxg=";
    "312-x86_64-linux" = "sha256-YI9xeOxuTko8JlRbCkT0S/g0ONBL8tlgzQ52meqpnvY=";
    "313-x86_64-linux" = "sha256-yfLcM0LkaGr5j24lncn7N38b9le2ScJHv2ZHu+T5gJA=";
    "314-x86_64-linux" = "sha256-evlCImnCv83s+d1VMJBgZlq5wtf2yJI3ftMsAyQA/uo=";
    "311-aarch64-linux" = "sha256-xCMLj9KXleiORB90nYgZc+yo2t8zxSYrNng5+4iR95s=";
    "312-aarch64-linux" = "sha256-3r1DUELAC+aLofs89ZMlp7q7P0o89HRMh93jRoAsu7Q=";
    "313-aarch64-linux" = "sha256-lNj8nfFyGwKHBGrKcgn9UECInK1CAue3Oh/bd82bccY=";
    "314-aarch64-linux" = "sha256-hHmCZSJz+3staUt4kgV0eq8+UK5kc4xct7XrA9hqmUc=";
    "311-aarch64-darwin" = "sha256-XhUtM0vzT7q9/o5bw1uH0fmUcGWST/g8KeZZMIs26Ug=";
    "312-aarch64-darwin" = "sha256-EIwOhnqiyH1JgsxjJaLeDE9b1jwr6hitsZOjcMQFlM4=";
    "313-aarch64-darwin" = "sha256-Kc9DNhU68TasisUo4u1G3xk2ftrn4U43vKGot8SEjvI=";
    "314-aarch64-darwin" = "sha256-l3VtLLo8XOIeFWAsKvWgJSHMDs2n+fttGNovO9UYJ/Q=";
  };
in
buildPythonPackage rec {
  pname = "tensorstore";
  version = "0.1.79";
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
