{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "wget";
  version = "3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NeYw7KKqUM6Zi5saEnuyazDf7lc3AngqqYL4dePxYGE=";
    extension = "zip";
  };

  meta = {
    description = "Pure python download utility";
    homepage = "https://bitbucket.org/techtonik/python-wget/";
    license = with lib.licenses; [ unlicense ];
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
