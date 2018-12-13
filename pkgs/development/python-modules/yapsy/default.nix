{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Yapsy";
  version = "1.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g1yd8nvhfdasckb929rijmj040x25ycns2b3l5wq53gm4lv537h";
  };

  meta = with stdenv.lib; {
    homepage = http://yapsy.sourceforge.net/;
    description = "Yet another plugin system";
    license = licenses.bsd0;
  };

}
