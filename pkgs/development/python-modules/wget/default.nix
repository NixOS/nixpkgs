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
    sha256 = "35e630eca2aa50ce998b9b1a127bb26b30dfee573702782aa982f875e3f16061";
    extension = "zip";
  };

  meta = {
    description = "Pure python download utility";
    homepage = "https://bitbucket.org/techtonik/python-wget/";
    license = with lib.licenses; [ unlicense ];
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
