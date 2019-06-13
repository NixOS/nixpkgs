{ lib
, fetchPypi
, buildPythonPackage
, docopt
, easywatch
, jinja2
}:

buildPythonPackage rec {
  pname = "staticjinja";
  version = "0.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fbd61cca1dad44b6891d1a1d72b11ae100e21b3909802e3ff1861ab55bf16603";
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

