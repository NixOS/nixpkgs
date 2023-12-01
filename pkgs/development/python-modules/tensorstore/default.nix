{ autoPatchelfHook
, buildPythonPackage
, fetchPypi
, lib
, numpy
, python
, stdenv
}:

let
  pythonVersionNoDot = builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  systemToPlatform = {
    "x86_64-linux" = "manylinux_2_17_x86_64.manylinux2014_x86_64";
    "aarch64-darwin" = "macosx_11_0_arm64";
  };
  hashes = {
    "310-x86_64-linux" = "sha256-Zuy2zBLV950CMbdtpLNpIWqnXHw2jkjrZG48eGtm42w=";
    "311-x86_64-linux" = "sha256-Bg5j8QB5z8Ju4bEQsZDojJHTJ4UoQF1pkd4ma83Sc/s=";
    "310-aarch64-darwin" = "sha256-6Tta4ru1TnobFa4FXWz8fm9rAxF0G09Y2Pj/KaQPVnE=";
    "311-aarch64-darwin" = "sha256-Sb0tv9ZPQJ4n9b0ybpjJWpreQPZvSC5Sd7CXuUwHCn0=";
  };
in
buildPythonPackage rec {
  pname = "tensorstore";
  version = "0.1.40";
  format = "wheel";

  # The source build involves some wonky Bazel stuff.
  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "cp${pythonVersionNoDot}";
    abi = "cp${pythonVersionNoDot}";
    dist = "cp${pythonVersionNoDot}";
    platform = systemToPlatform.${stdenv.system} or (throw "unsupported system");
    hash = hashes."${pythonVersionNoDot}-${stdenv.system}" or (throw "unsupported system/python version combination");
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  propagatedBuildInputs = [ numpy ];

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
