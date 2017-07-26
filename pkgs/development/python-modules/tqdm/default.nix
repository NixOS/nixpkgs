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
  version = "4.11.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14baa7a9ea7723d46f60de5f8c6f20e840baa7e3e193bf0d9ec5fe9103a15254";
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
