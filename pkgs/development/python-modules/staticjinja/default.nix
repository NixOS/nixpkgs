{ lib
, fetchPypi
, buildPythonPackage
, docopt
, easywatch
, jinja2
}:

buildPythonPackage rec {
  pname = "staticjinja";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "597837899008409359680ee9cd04779639b9c0eb3380b6545025d26a702ba36c";
  };

  propagatedBuildInputs = [ jinja2 docopt easywatch ];

  # There are no tests on pypi
  doCheck = false;

  meta = with lib; {
    description = "A library and cli tool that makes it easy to build static sites using Jinja2";
    homepage = "https://staticjinja.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}

