{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, numpy
, pandas
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
, rich
, setuptools-scm
, tkinter
}:

buildPythonPackage rec {
  pname = "tqdm";
  version = "4.65.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GHH7aKhrj7O1nKTN09zMvH5tYT7u0x9MMyUxl3uJvrU=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

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

  # Remove performance testing.
  # Too sensitive for on Hydra.
  disabledTests = [
    "perf"
  ];

  LC_ALL="en_US.UTF-8";

  pythonImportsCheck = [
    "tqdm"
  ];

  meta = with lib; {
    description = "A Fast, Extensible Progress Meter";
    homepage = "https://github.com/tqdm/tqdm";
    changelog = "https://github.com/tqdm/tqdm/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fridh ];
  };
}
