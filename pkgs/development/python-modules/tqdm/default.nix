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
  version = "4.48.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "564d632ea2b9cb52979f7956e093e831c28d441c11751682f84c86fc46e4fd21";
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
