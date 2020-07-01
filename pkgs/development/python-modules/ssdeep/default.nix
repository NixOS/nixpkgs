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
  version = "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0px8k4fjbkjb717bg2v7rjhm4iclrxzq7sh0hfqs55f4ddqi0m8v";
  };

  buildInputs = [ pkgs.ssdeep pytestrunner ];
  checkInputs = [ pytest ];
  propagatedBuildInputs = [ cffi six ];

  # tests repository does not include required files
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/DinoTools/python-ssdeep";
    description = "Python wrapper for the ssdeep library";
    license = licenses.lgpl3;
  };

}
