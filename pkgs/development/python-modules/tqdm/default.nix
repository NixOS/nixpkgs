{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, setuptools-scm
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
  version = "4.62.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d359de7217506c9851b7869f3708d8ee53ed70a1b8edbba4dbcb47442592920d";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
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
    # pytest-asyncio 0.17.0 compat; https://github.com/tqdm/tqdm/issues/1289
    "--asyncio-mode=strict"
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
    homepage = "https://github.com/tqdm/tqdm";
    changelog = "https://tqdm.github.io/releases/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fridh ];
  };
}
