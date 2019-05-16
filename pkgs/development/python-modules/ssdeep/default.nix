{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
, cffi
, six
, pytest
, pytestrunner
}:

buildPythonPackage rec {
  pname = "ssdeep";
  version = "3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "255de1f034652b3ed21920221017e70e570b1644f9436fea120ae416175f4ef5";
  };

  buildInputs = [ pkgs.ssdeep pytestrunner ];
  checkInputs = [ pytest ];
  propagatedBuildInputs = [ cffi six ];

  # tests repository does not include required files
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/DinoTools/python-ssdeep;
    description = "Python wrapper for the ssdeep library";
    license = licenses.lgpl3;
  };

}
