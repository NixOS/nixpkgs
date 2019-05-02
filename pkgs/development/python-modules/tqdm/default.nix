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
  version = "4.31.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e22977e3ebe961f72362f6ddfb9197cc531c9737aaf5f607ef09740c849ecd05";
  };

  buildInputs = [ nose coverage glibcLocales flake8 ];

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
    homepage = https://github.com/tqdm/tqdm;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
