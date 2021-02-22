{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
, glibcLocales
, flake8
, setuptools_scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tqdm";
  version = "4.54.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x9chlh3msikddmq8p8p5s5kgqqs48bclxgzz3vb9ygcwjimidiq";
  };

  nativeBuildInputs = [
    setuptools_scm
  ];

  checkInputs = [ nose coverage glibcLocales flake8 pytestCheckHook ];

  # Remove performance testing.
  # Too sensitive for on Hydra.
  PYTEST_ADDOPTS = "-k \"not perf\"";

  LC_ALL="en_US.UTF-8";

  meta = {
    description = "A Fast, Extensible Progress Meter";
    homepage = "https://github.com/tqdm/tqdm";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
