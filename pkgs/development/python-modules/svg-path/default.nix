{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "svg.path";
  version = "4.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4bd627ec6526cd5da14f3c6a51205d930187db2d8992aed626825492c033b195";
  };

  meta = with stdenv.lib; {
    description = "SVG path objects and parser";
    homepage = https://github.com/regebro/svg.path;
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
  };
}
