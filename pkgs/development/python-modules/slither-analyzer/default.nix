{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # nativeBuildInputs
  makeWrapper,

  # dependencies
  crytic-compile,
  packaging,
  prettytable,
  web3,

  # tests
  versionCheckHook,
  writableTmpDirAsHomeHook,

  # postFixup
  solc,

  withSolc ? false,
}:

buildPythonPackage (finalAttrs: {
  pname = "slither-analyzer";
  version = "0.11.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "slither";
    tag = finalAttrs.version;
    hash = "sha256-sy1vE9XniwyvvZRFnnKhPfmYh2auHHcMel9sZx2YK3c=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ makeWrapper ];

  dependencies = [
    crytic-compile
    packaging
    prettytable
    web3
  ];

  nativeCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  postFixup = lib.optionalString withSolc ''
    wrapProgram $out/bin/slither \
      --prefix PATH : "${lib.makeBinPath [ solc ]}"
  '';

  pythonImportsCheck = [
    "slither"
    "slither.all_exceptions"
    "slither.analyses"
    "slither.core"
    "slither.detectors"
    "slither.exceptions"
    "slither.formatters"
    "slither.printers"
    "slither.slither"
    "slither.slithir"
    "slither.solc_parsing"
    "slither.utils"
    "slither.visitors"
    "slither.vyper_parsing"
  ];

  meta = {
    description = "Static Analyzer for Solidity";
    longDescription = ''
      Slither is a Solidity static analysis framework written in Python 3. It
      runs a suite of vulnerability detectors, prints visual information about
      contract details, and provides an API to easily write custom analyses.
    '';
    homepage = "https://github.com/trailofbits/slither";
    changelog = "https://github.com/crytic/slither/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Plus;
    mainProgram = "slither";
    maintainers = with lib.maintainers; [
      arturcygan
      fab
      hellwolf
    ];
  };
})
