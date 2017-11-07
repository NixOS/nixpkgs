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
  version = "4.19.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ca803c2ea268c6bdb541e2dac74a3af23cf4bf7b4132a6a78926d255f8c8df1";
  };

  buildInputs = [ nose coverage glibcLocales flake8 ];

  LC_ALL="en_US.UTF-8";

  meta = {
    description = "A Fast, Extensible Progress Meter";
    homepage = https://github.com/tqdm/tqdm;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
