{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "translationstring";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ee44cfa58c52ade8910ea0ebc3d2d84bdcad9fa0422405b1801ec9b9a65b72d";
  };

  meta = with stdenv.lib; {
    homepage = https://pylonsproject.org/;
    description = "Utility library for i18n relied on by various Repoze and Pyramid packages";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };

}
