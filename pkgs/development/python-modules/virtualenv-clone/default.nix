{ lib
, buildPythonPackage
, fetchPypi
, virtualenv
}:

buildPythonPackage rec {
  pname = "virtualenv-clone";
  version = "0.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "997c7d225eabc4d09e77672461f4bdf9f3a8ea9dc9e4a847b0e83dc8bad9573a";
  };

  propagatedBuildInputs = [ virtualenv ];

  # tests are not included in pypi tarball and no module to import
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/edwardgeorge/virtualenv-clone";
    description = "Script to clone virtualenvs";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
