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
    "311-x86_64-linux" = "sha256-iudEUatcyKDNnlGSat8E9N/b2K1awxrHHxyqe9+ygo0=";
    "312-x86_64-linux" = "sha256-ZMgDlVjVYHtzkDlI/OBYclcx30EMXBls9Ys/xiIjlbU=";
    "313-x86_64-linux" = "sha256-jqU6hR6oaq09mcFKeQyFRo1jJL4Ux6whHx8CZej6twc=";
    "314-x86_64-linux" = "sha256-fJEIrmwprckLcsome6K1dzhsXkEOovjofqvOXr2tMn4=";
    "311-aarch64-linux" = "sha256-NDUvi6bl77pf6xiRfWjaGpK7/4DmTD/QbT0a9LNDgho=";
    "312-aarch64-linux" = "sha256-Os4Azy5F3F1k/joQwsvvYTQ5FWg4CKEKPggSM1ZqcjE=";
    "313-aarch64-linux" = "sha256-UK+wbFelCQkQFa9qhdpvSDp/WtA3IoTdldVRPYdzNuQ=";
    "314-aarch64-linux" = "sha256-Gy/11VNqipsVlsUbkHXMnUC0xOpObMA8BIARHb5dlW0=";
    "311-aarch64-darwin" = "sha256-NA/pcfGAjXBg8ic7ju41J4C8tl5QNfeBY/qbiTCqeVo=";
    "312-aarch64-darwin" = "sha256-RHfqvibi9RMfGxo0RM2RZ/5p+rwpV56rglnSGDmbnms=";
    "313-aarch64-darwin" = "sha256-AoRVzM3AXDHxlASM9FmiZmmybTjwUWyvkhPnIZse55o=";
    "314-aarch64-darwin" = "sha256-19AXdZhfyqKw8QA0l2apU8UIbpLnRr85XpNhUdTY+aw=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "tensorstore";
  version = "0.1.84";
  format = "wheel";
  __structuredAttrs = true;

  # The source build involves some wonky Bazel stuff.
  src = fetchPypi {
    inherit (finalAttrs) pname version;
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
    changelog = "https://github.com/google/tensorstore/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ samuela ];
  };
})
