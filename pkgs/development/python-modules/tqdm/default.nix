{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
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
  version = "4.66.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2I5lH5242FUaYlVtPP+eMDQnTKXWbpMZfPJJDi3Lacc=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/advisories/GHSA-g7vv-2v7x-gj9p
      name = "CVE-2024-34062.patch";
      url = "https://github.com/tqdm/tqdm/commit/4e613f84ed2ae029559f539464df83fa91feb316.patch";
      hash = "sha256-4HgLKlJfbLDQO81vNJG4SwsEUMc3dr6E9KE/i34OYF8=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
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

  pytestFlagsArray = [
    "-W" "ignore::FutureWarning"
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
