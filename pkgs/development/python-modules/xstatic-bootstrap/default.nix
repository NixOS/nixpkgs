{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic-Bootstrap";
  version = "4.5.3.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "cf67d205437b32508a88b69a7e7c5bbe2ca5a8ae71097391a6a6f510ebfd2820";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib;{
    homepage = "https://getbootstrap.com";
    description = "Bootstrap packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
