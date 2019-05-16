{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "svg.path";
  version = "3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7b568f90f67fd25413c8da9f8bc9f9f8ab089425c20fa03330e97e77d13880ee";
  };

  meta = with stdenv.lib; {
    description = "SVG path objects and parser";
    homepage = https://github.com/regebro/svg.path;
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
  };
}
