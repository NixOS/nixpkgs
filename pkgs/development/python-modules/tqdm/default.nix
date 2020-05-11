{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
, glibcLocales
, flake8
}:

buildPythonPackage rec {
  pname = "tqdm";
  version = "4.46.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4733c4a10d0f2a4d098d801464bdaf5240c7dadd2a7fde4ee93b0a0efd9fb25e";
  };

  checkInputs = [ nose coverage glibcLocales flake8 ];

  postPatch = ''
    # Remove performance testing.
    # Too sensitive for on Hydra.
    rm tqdm/tests/tests_perf.py
  '';

  LC_ALL="en_US.UTF-8";

#   doCheck = !stdenv.isDarwin;
  # Test suite is too big and slow.
  doCheck = false;

  meta = {
    description = "A Fast, Extensible Progress Meter";
    homepage = "https://github.com/tqdm/tqdm";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
