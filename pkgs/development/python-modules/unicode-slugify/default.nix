{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
, unittest2
, unidecode
}:

buildPythonPackage rec {
  pname = "unicode-slugify";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l7nphfdq9rgiczbl8n3mra9gx7pxap0xz540pkyz034zbz3mkrl";
  };

  propagatedBuildInputs = [ six unidecode ];

  checkInputs = [ nose unittest2 ];

  meta = with lib; {
    description = "Generates unicode slugs";
    homepage = "https://pypi.org/project/unicode-slugify/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
