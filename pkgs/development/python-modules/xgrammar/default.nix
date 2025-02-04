{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  python,
  pythonOlder,
  pythonAtLeast,
  pydantic,
  sentencepiece,
  tiktoken,
  torch,
  transformers,
  triton,
}:

let
  pyShortVersion = "cp" + builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  platforms = rec {
    aarch64-darwin = "macosx_13_0_arm64";
    x86_64-darwin = "macosx_10_15_x86_64";
    x86_64-linux = "manylinux_2_27_x86_64.manylinux_2_28_x86_64";
  };
  platform = platforms.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  # hashes retrieved via the following command
  # curl https://pypi.org/pypi/xgrammar/${version}/json | jq -r '.urls[] | "\(.digests.sha256)  \(.filename)"'
  hashes = rec {
    cp39-aarch64-darwin = "12dd579a7073c14981e01aeee566d20e60001bf90af23024e0e6692a770ff535";
    cp39-x86_64-darwin = "035ec93306543b99bf2141dcc7f1a6dd0c255753fc8b5a2b5f3289a59fed8e37";
    cp39-x86_64-linux = "3b3975dcf4b3ed7b16bbe3c068738b09847f841793e1c5e1b4a07dff36bbdc37";
    cp310-aarch64-darwin = "93bb6c10cbdf1a2bda3b458d97b47436657d780f98dccf3d266e17e13568c0a9";
    cp310-x86_64-darwin = "5ed31db2669dc499d9d29bb16f30b3395332ff9d0fb80b759697190a5ef5258b";
    cp310-x86_64-linux = "9c6f571121e4af45e3b5dc55f3dadd751cffff1f85f1c6fc5c4276db2bbed222";
    cp311-aarch64-darwin = "b293443725eddad31cf7b407bb24d5f3156c4b12a2c8041743cb7068a69fadcb";
    cp311-x86_64-darwin = "b2106bceb2ce313628af915f2c2b1c9865612026dd3c9feddbfcc69e4ee6c971";
    cp311-x86_64-linux = "7934c968371d55759cac35be3b218cdf4b13f323f535ea0faa233240bab803b9";
    cp312-aarch64-darwin = "561f8d4307db8cf5d3c3b3ff46eda6d95379f6e801278dbf9153a9d5e8b6126c";
    cp312-x86_64-darwin = "6ac3cbb0a82a3a9d07f0739f63b2e26cbef7855149d236057dcc7fee74b37970";
    cp312-x86_64-linux = "1854d0fe6b908a3d2d42251a62e627224dbf6035a4322b844b1b5a277e3d0461";
  };
  hash =
    hashes."${pyShortVersion}-${stdenv.system}"
      or (throw "Unsupported Python version: ${python.pythonVersion}");
in
buildPythonPackage rec {
  pname = "xgrammar";
  version = "0.1.11";
  format = "wheel";

  disabled = pythonOlder "3.9" || pythonAtLeast "3.13";

  src = fetchPypi {
    inherit pname version format;
    dist = pyShortVersion;
    python = pyShortVersion;
    abi = pyShortVersion;
    platform = platform;
    sha256 = hash;
  };

  pythonImportCheck = [ "xgrammar" ];

  dependencies = [
    pydantic
    sentencepiece
    tiktoken
    torch
    transformers
    triton
  ];

  meta = with lib; {
    description = "Efficient, Flexible and Portable Structured Generation";
    homepage = "https://xgrammar.mlc.ai";
    license = licenses.asl20;
  };
}
