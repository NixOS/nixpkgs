{ lib
, buildPythonPackage
, fetchPypi
, rednose
, six
, mock
, isPyPy
}:

buildPythonPackage rec {
  pname = "sure";
  version = "2.0.0";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "34ae88c846046742ef074036bf311dc90ab152b7bc09c342b281cebf676727a2";
  };

  buildInputs = [ rednose ];
  propagatedBuildInputs = [ six mock ];

  meta = with lib; {
    description = "Utility belt for automated testing";
    homepage = "https://sure.readthedocs.io/en/latest/";
    license = licenses.gpl3Plus;
  };

}
