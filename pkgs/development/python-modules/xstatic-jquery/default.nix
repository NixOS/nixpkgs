{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic-jQuery";
  version = "3.3.1.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0xlgs4rlabzfcp8p2zspwpsljycb0djyrk7qy4qh76i7zkfhwn8j";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib;{
    homepage =  https://jquery.org;
    description = "jquery packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
