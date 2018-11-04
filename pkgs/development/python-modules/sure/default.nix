{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, six
, mock
, pkgs
, isPyPy
}:

buildPythonPackage rec {
  pname = "sure";
  version = "1.4.11";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c8d5271fb18e2c69e2613af1ad400d8df090f1456081635bd3171847303cdaa";
  };

  LC_ALL="en_US.UTF-8";

  buildInputs = [ nose pkgs.glibcLocales ];
  propagatedBuildInputs = [ six mock ];

  meta = with stdenv.lib; {
    description = "Utility belt for automated testing";
    homepage = https://falcao.it/sure/;
    license = licenses.gpl3Plus;
  };

}
