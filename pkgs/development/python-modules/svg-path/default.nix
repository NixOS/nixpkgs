{ lib, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "svg.path";
  version = "4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e6847ba690ff620e20f152818d52e1685b993aacbc41b321f8fee3d1cb427db";
  };

  meta = with lib; {
    description = "SVG path objects and parser";
    homepage = "https://github.com/regebro/svg.path";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
  };
}
