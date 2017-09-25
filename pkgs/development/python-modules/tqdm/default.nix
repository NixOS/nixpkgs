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
  version = "4.15.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ec1dc74efacf2cda936b4a6cf4082ce224c76763bdec9f17e437c8cfcaa9953";
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
