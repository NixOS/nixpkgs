{ stdenv, buildPythonPackage, fetchPypi, pbr, six, argparse }:

buildPythonPackage rec {
  pname = "stevedore";
  version = "1.29.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e153545aca7a6a49d8337acca4f41c212fbfa60bf864ecd056df0cafb9627e8";
  };

  doCheck = false;

  propagatedBuildInputs = [ pbr six argparse ];

  meta = with stdenv.lib; {
    description = "Manage dynamic plugins for Python applications";
    homepage = https://pypi.python.org/pypi/stevedore;
    license = licenses.asl20;
  };
}
