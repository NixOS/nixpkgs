{
  buildPythonPackage,
  lib,
  fetchPypi,
  xstatic-jquery,
}:

buildPythonPackage rec {
  pname = "xstatic-jquery-ui";
  version = "1.13.0.1";

  src = fetchPypi {
    pname = "XStatic-jquery-ui";
    inherit version;
    hash = "sha256-Npfl8O81W49KHHJCIVkmg8LbAxk1y7V7RiJO70dL0pQ=";
  };

  # no tests implemented
  doCheck = false;

  propagatedBuildInputs = [ xstatic-jquery ];

  meta = with lib; {
    homepage = "https://jqueryui.com/";
    description = "jquery-ui packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
