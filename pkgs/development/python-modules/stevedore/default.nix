{ stdenv, buildPythonPackage, fetchPypi, oslosphinx, pbr, six, argparse }:

buildPythonPackage rec {
  pname = "stevedore";
  version = "1.25.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4def435de90ba69c69954e641cdf877f5e5d660568c355c5c6805710c15d8504";
  };

  doCheck = false;

  buildInputs = [ oslosphinx ];
  propagatedBuildInputs = [ pbr six argparse ];

  meta = with stdenv.lib; {
    description = "Manage dynamic plugins for Python applications";
    homepage = https://pypi.python.org/pypi/stevedore;
    license = licenses.asl20;
  };
}
