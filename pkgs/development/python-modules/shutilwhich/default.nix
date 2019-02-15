{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "shutilwhich";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ijdnvn101ixwhayd4x4khf73xwhj33vhyv1z8qgchhy8v33j7yv";
  };

  meta = with lib; {
    homepage = https://github.com/mbr/shutilwhich;
    description = "shutil.which for legacy below Python 3.3";
    license = licenses.psfl;
    maintainers = with maintainers; [ leenaars ];
  };
}
