{ stdenv, buildPythonPackage, fetchPypi, oslosphinx, pbr, six, argparse }:

buildPythonPackage rec {
  pname = "stevedore";
  version = "1.25.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8a373b90487b7a1b52ebaa3ca5059315bf68d9ebe15b2203c2fa675bd7e1e7e";
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
