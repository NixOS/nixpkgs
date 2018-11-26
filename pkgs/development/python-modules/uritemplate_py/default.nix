{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "uritemplate.py";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k5zvc5fyyrgv33mi3p86a9jn5n0pqffs9cviz92fw6q1kf7zvmr";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/uri-templates/uritemplate-py;
    description = "Python implementation of URI Template";
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
  };

}
