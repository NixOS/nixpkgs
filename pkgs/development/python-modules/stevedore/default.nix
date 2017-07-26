{ stdenv, buildPythonPackage, fetchPypi, oslosphinx, pbr, six, argparse }:

buildPythonPackage rec {
  pname = "stevedore";
  version = "1.21.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12sg88ax0lv2sxr685rqdaxm9gryjrpj4fvax459zvwy1r4n83ma";
  };

  doCheck = false;

  buildInputs = [ oslosphinx ];
  propagatedBuildInputs = [ pbr six argparse ];

  meta = with stdenv.lib; {
    description = "Manage dynamic plugins for Python applications";
    homepage = "https://pypi.python.org/pypi/stevedore";
    license = licenses.asl20;
  };
}
