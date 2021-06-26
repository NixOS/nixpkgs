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
  version = "4.61.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "24be966933e942be5f074c29755a95b315c69a91f839a29139bf26ffffe2d3fd";
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
