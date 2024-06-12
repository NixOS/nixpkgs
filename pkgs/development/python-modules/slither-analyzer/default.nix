{
  lib,
  stdenv,
  buildPythonPackage,
  crytic-compile,
  fetchFromGitHub,
  makeWrapper,
  packaging,
  prettytable,
  pythonOlder,
  setuptools-scm,
  solc,
  web3,
  withSolc ? false,
  testers,
  slither-analyzer,
}:

buildPythonPackage rec {
  pname = "slither-analyzer";
  version = "0.10.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "slither";
    rev = "refs/tags/${version}";
    hash = "sha256-KmbmljtmMtrJxgSMJjQ8fdk6RpEXcAVBuo24EsyMV8k=";
  };

  nativeBuildInputs = [
    makeWrapper
    setuptools-scm
  ];

  propagatedBuildInputs = [
    crytic-compile
    packaging
    prettytable
    web3
  ];

  postFixup = lib.optionalString withSolc ''
    wrapProgram $out/bin/slither \
      --prefix PATH : "${lib.makeBinPath [ solc ]}"
  '';

  # required for pythonImportsCheck
  postInstall = ''
    export HOME="$TEMP"
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

  # Test if the binary works during the build phase.
  checkPhase = ''
    runHook preCheck

    HOME="$TEMP" $out/bin/slither --version

    runHook postCheck
  '';

  passthru.tests.version = testers.testVersion {
    package = slither-analyzer;
    command = "HOME=$TMPDIR slither --version";
    version = "${version}";
  };

  meta = with lib; {
    description = "Static Analyzer for Solidity";
    longDescription = ''
      Slither is a Solidity static analysis framework written in Python 3. It
      runs a suite of vulnerability detectors, prints visual information about
      contract details, and provides an API to easily write custom analyses.
    '';
    homepage = "https://github.com/trailofbits/slither";
    changelog = "https://github.com/crytic/slither/releases/tag/${version}";
    license = licenses.agpl3Plus;
    mainProgram = "slither";
    maintainers = with maintainers; [
      arturcygan
      fab
      hellwolf
    ];
  };
}
