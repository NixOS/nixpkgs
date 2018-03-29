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
  version = "4.19.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ec0d4442358e55cdb4a0471d04c6c831518fd8837f259db5537d90feab380df";
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
