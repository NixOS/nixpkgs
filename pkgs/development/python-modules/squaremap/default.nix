{ stdenv
, buildPythonPackage
, isPy3k
, fetchPypi
}:

buildPythonPackage rec {
  pname = "squaremap";
  version = "1.0.5";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b16ce5950cbfa63e3284015095293cd26ed5e26045fd14d488fb825b4f95e9a8";
  };

  meta = with stdenv.lib; {
    description = "Hierarchic visualization control for wxPython";
    homepage = https://launchpad.net/squaremap;
    license = licenses.bsd3;
  };

}
