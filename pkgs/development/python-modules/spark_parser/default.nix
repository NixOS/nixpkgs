{ lib
, buildPythonPackage
, fetchPypi
, nose
, click
}:

buildPythonPackage rec {
  pname = "spark_parser";
  version = "1.8.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0np2y4jcir4a4j18wws7yzkz2zj6nqhdhn41rpq8pyskg6wrgfx7";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ click ];

  meta = with lib; {
    description = "An Early-Algorithm Context-free grammar Parser";
    homepage = "https://github.com/rocky/python-spark";
    license = licenses.mit;
    maintainers = with maintainers; [raskin];
  };

}
