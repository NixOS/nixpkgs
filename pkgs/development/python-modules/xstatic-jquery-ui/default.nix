{ buildPythonPackage
, lib
, fetchPypi
, xstatic-jquery
}:

buildPythonPackage rec {
  pname = "XStatic-jquery-ui";
  version = "1.13.0.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "3697e5f0ef355b8f4a1c724221592683c2db031935cbb57b46224eef474bd294";
  };

  # no tests implemented
  doCheck = false;

  propagatedBuildInputs = [ xstatic-jquery ];

  meta = with lib;{
    homepage = "https://jqueryui.com/";
    description = "jquery-ui packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
