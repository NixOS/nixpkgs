{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Yapsy";
  version = "1.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f08cb229a96f14cc0b1d4b68cb7c111d1020ab8c3989b426d3aa39b82d6a3e3c";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://yapsy.sourceforge.net/;
    description = "Yet another plugin system";
    license = licenses.bsd0;
  };

}
