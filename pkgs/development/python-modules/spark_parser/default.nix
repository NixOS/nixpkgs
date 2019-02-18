{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, click
}:

buildPythonPackage rec {
  pname = "spark_parser";
  version = "1.8.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c5e6064afbb3c114749016d585b0e4f9222d4ffa97a1854c9ab70b25783ef48";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ click ];

  meta = with stdenv.lib; {
    description = ''An Early-Algorithm Context-free grammar Parser'';
    homepage = "https://github.com/rocky/python-spark";
    license = licenses.mit;
    maintainers = with maintainers; [raskin];
  };

}
