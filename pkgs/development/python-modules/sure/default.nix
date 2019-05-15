{ stdenv
, buildPythonPackage
, fetchPypi
, rednose
, six
, mock
, isPyPy
}:

buildPythonPackage rec {
  pname = "sure";
  version = "1.4.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c8d5271fb18e2c69e2613af1ad400d8df090f1456081635bd3171847303cdaa";
  };

  doCheck = !isPyPy;

  buildInputs = [ rednose ];
  propagatedBuildInputs = [ six mock ];

  meta = with stdenv.lib; {
    description = "Utility belt for automated testing";
    homepage = https://sure.readthedocs.io/en/latest/;
    license = licenses.gpl3Plus;
  };

}
