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
    sha256 = "d6ba48bb474420a8bcb2be02eef6ae96281ec24eff6befa54f04ebc9e4cc8910";
  };

  # no tests implemented
  doCheck = false;

  propagatedBuildInputs = [ xstatic-jquery ];

  meta = with lib;{
    homepage = https://jqueryui.com/;
    description = "jquery-ui packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
