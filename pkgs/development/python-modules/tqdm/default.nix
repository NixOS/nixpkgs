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
  version = "4.23.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "77b8424d41b31e68f437c6dd9cd567aebc9a860507cb42fbd880a5f822d966fe";
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
