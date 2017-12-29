{ stdenv, buildPythonPackage, fetchPypi, oslosphinx, pbr, six, argparse }:

buildPythonPackage rec {
  pname = "stevedore";
  version = "1.27.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "236468dae36707069e8b3bdb455e9f1be090b1e6b937f4ac0c56a538d6f50be0";
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
