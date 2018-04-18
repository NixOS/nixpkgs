{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
, glibcLocales
, flake8
, matplotlib
, pandas
}:

buildPythonPackage rec {
  pname = "tqdm";
  version = "4.21.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b94af236084ceaad93a6ada00bd9976900b172ec9b821828ed0d4b53f7431170";
  };

  buildInputs = [ nose coverage glibcLocales flake8 ];

  postPatch = ''
    # Remove performance testing.
    # Too sensitive for on Hydra.
    rm tqdm/tests/tests_perf.py
  '';

  LC_ALL="en_US.UTF-8";

  meta = {
    description = "A Fast, Extensible Progress Meter";
    homepage = https://github.com/tqdm/tqdm;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
