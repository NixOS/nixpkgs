{ stdenv, buildPythonPackage, fetchPypi, pbr, six, argparse }:

buildPythonPackage rec {
  pname = "stevedore";
  version = "1.28.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1c7518e7b160336040fee272174f1f7b29a46febb3632502a8f2055f973d60b";
  };

  doCheck = false;

  propagatedBuildInputs = [ pbr six argparse ];

  meta = with stdenv.lib; {
    description = "Manage dynamic plugins for Python applications";
    homepage = https://pypi.python.org/pypi/stevedore;
    license = licenses.asl20;
  };
}
