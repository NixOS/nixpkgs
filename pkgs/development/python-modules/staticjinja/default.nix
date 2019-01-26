{ lib
, fetchPypi
, buildPythonPackage
, docopt
, easywatch
, jinja2
}:

buildPythonPackage rec {
  pname = "staticjinja";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mxv7yy35657mfxx9xhbzihh10m5lb29fmscfh9q455zd4ikr032";
  };

  propagatedBuildInputs = [ jinja2 docopt easywatch ];

  # There are no tests on pypi
  doCheck = false;

  meta = with lib; {
    description = "A library and cli tool that makes it easy to build static sites using Jinja2";
    homepage = https://staticjinja.readthedocs.io/en/latest/;
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}

