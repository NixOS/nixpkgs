{ buildPythonPackage
, lib
, fetchPypi
, xstatic-jquery
}:

buildPythonPackage rec {
  pname = "XStatic-jquery-ui";
  version = "1.12.1.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0449rkjcksq49yjyyszz9v11wa4nmvvfw0mynayah8248yxlifnn";
  };

  # no tests implemented
  doCheck = false;

  propagatedBuildInputs = [ xstatic-jquery ];

  meta = with lib;{
    homepage = http://jqueryui.com/;
    description = "jquery-ui packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
