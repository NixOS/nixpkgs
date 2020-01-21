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
  version = "4.40.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0ab01cf3ae5673d18f918700c0165e5fad0f26b5ebe4b34f62ead92686b5340";
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
    homepage = https://github.com/tqdm/tqdm;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
