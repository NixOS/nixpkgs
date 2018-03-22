{ buildPythonPackage
, lib
, fetchPypi
, xstatic-jquery
}:

buildPythonPackage rec {
  pname = "XStatic-jquery-ui";
  version = "1.12.0.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0w7mabv6qflpd47g33j3ggp5rv17mqk0xz3bsdswcj97wqpga2l2";
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
