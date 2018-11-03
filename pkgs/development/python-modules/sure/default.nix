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
  version = "1.2.24";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lyjq0rvkbv585dppjdq90lbkm6gyvag3wgrggjzyh7cpyh5c12w";
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
