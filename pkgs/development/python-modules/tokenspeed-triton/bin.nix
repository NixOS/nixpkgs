{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  pythonAtLeast,
  stdenv,

  # nativeBuildInputs
  autoPatchelfHook,
  pypaInstallHook,
  wheelUnpackHook,

  # buildInputs
  zlib,
}:
let
  inherit (stdenv.hostPlatform) system;
  pythonVersion = if pythonAtLeast "3.12" then "3.12" else python.pythonVersion;
  abiTag = if pythonAtLeast "3.12" then "abi3" else pythonTag;
  pythonTag = "cp${lib.replaceStrings [ "." ] [ "" ] pythonVersion}";

  hashes = {
    aarch64-linux = {
      cp310 = "sha256-fkYRq6wkAavw4BwOHOt8aybu+IfRLLvrD5oU6JFTHlw=";
      cp311 = "sha256-tGfvQ4M7eOqfndLnC842WevPx6N1HjTzHI/+4g0S1+U=";
      abi3 = "sha256-KZ9Ygd4Go0SNjk9L/s32/58UiWk7rxYwPehBa6gsFtY=";
    };
    x86_64-linux = {
      cp310 = "sha256-vHTyzQZDGs5gt3dkBSaA3QGK5rDFpC0NPWk9dOTRmVw=";
      cp311 = "sha256-9qMpxrtZSfKxTUdJ1ulwWUwxvTUniPtc7sjkmxffWbw=";
      abi3 = "sha256-616ubE09sR4TtwWMibV+B1+n35BdQxac/bBm4WGIZCE=";
    };
  };
in
buildPythonPackage (finalAttrs: {
  pname = "tokenspeed-triton";
  version = "3.8.10.post20260920";
  pyproject = false;
  __structuredAttrs = true;

  src = fetchPypi {
    format = "wheel";
    pname = "tokenspeed_triton";
    inherit (finalAttrs) version;
    dist = pythonTag;
    python = pythonTag;
    abi = abiTag;
    platform = "manylinux_2_27_${stdenv.hostPlatform.uname.processor}.manylinux_2_28_${stdenv.hostPlatform.uname.processor}";
    hash = hashes.${system}.${abiTag} or (throw "Unsupported system: ${system}");
  };

  nativeBuildInputs = [
    autoPatchelfHook
    pypaInstallHook
    wheelUnpackHook
  ];

  buildInputs = [ zlib ];

  pythonImportsCheck = [ "tokenspeed_triton" ];

  meta = {
    description = "Language and compiler for custom Deep Learning operations";
    homepage = "https://github.com/lightseekorg/triton";
    downloadPage = "https://pypi.org/project/tokenspeed-triton/#files";
    changelog = "https://github.com/lightseekorg/triton/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ prince213 ];
    platforms = lib.attrNames hashes;
  };
})
