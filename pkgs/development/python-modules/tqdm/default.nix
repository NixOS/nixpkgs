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
  version = "4.25.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a3364bd83ce4777320b862e3c8a93d7da91e20a95f06ef79bed7dd71c654cafa";
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
