{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, setuptools_scm
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
  version = "4.60.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ebdebdb95e3477ceea267decfc0784859aa3df3e27e22d23b83e9b272bf157ae";
  };

  nativeBuildInputs = [
    setuptools_scm
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
    # pandas is not supported on i686
    lib.optional (!stdenv.isi686) pandas;

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
