{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, setuptools-scm
, wheel
, pytestCheckHook
, pytest-asyncio
, pytest-timeout
, numpy
, pandas
, rich
, tkinter
}:

buildPythonPackage rec {
  pname = "tqdm";
  version = "4.66.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bNUs3w/vDg9UMpnPyW/skNe4p+iHRfQR7DPrRNXtNTE=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  # https://github.com/tqdm/tqdm/issues/1537
  doCheck = pythonOlder "3.12";

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
    # tests of optional features
    numpy
    rich
    tkinter
  ] ++
    # pandas is not supported on i686 or risc-v
    lib.optional (!stdenv.isi686 && !stdenv.hostPlatform.isRiscV) pandas;

  pytestFlagsArray = [
    "-W" "ignore::FutureWarning"
    "-W" "ignore::DeprecationWarning"
  ];

  # Remove performance testing.
  # Too sensitive for on Hydra.
  disabledTests = [
    "perf"
  ];

  LC_ALL="en_US.UTF-8";

  pythonImportsCheck = [ "tqdm" ];

  meta = with lib; {
    description = "A Fast, Extensible Progress Meter";
    mainProgram = "tqdm";
    homepage = "https://github.com/tqdm/tqdm";
    changelog = "https://tqdm.github.io/releases/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fridh ];
  };
}
