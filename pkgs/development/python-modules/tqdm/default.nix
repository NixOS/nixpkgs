{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
, glibcLocales
, flake8
, stdenv
}:

buildPythonPackage rec {
  pname = "tqdm";
  version = "4.28.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b4d5549984503050883bc126280b386f5f4ca87e6c023c5d015655ad75bdebb";
  };

  buildInputs = [ nose coverage glibcLocales flake8 ];

  postPatch = ''
    # Remove performance testing.
    # Too sensitive for on Hydra.
    rm tqdm/tests/tests_perf.py
  '';

  LC_ALL="en_US.UTF-8";

  doCheck = !stdenv.isDarwin;

  meta = {
    description = "A Fast, Extensible Progress Meter";
    homepage = https://github.com/tqdm/tqdm;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
