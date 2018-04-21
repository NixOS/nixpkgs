{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "svg.path";
  version = "2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08kp03i4yiqdkz7a7l7d7kzszahmhigrml2502zi1ybndrh7ayxw";
  };

  meta = with stdenv.lib; {
    description = "SVG path objects and parser";
    homepage = https://github.com/regebro/svg.path;
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
  };
}
