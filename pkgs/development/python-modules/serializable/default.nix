{ stdenv, buildPythonPackage, fetchPypi,
typechecks, six, simplejson, nose}:

buildPythonPackage rec {
  version = "0.2.1";
  pname = "serializable";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec604e5df0c1236c06d190043a407495c4412dd6b6fd3b45a8514518173ed961";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ typechecks six simplejson ];

  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/iskandr/serializable";
    description = "Base class with serialization methods for user-defined Python objects";
    license = licenses.asl20;
    maintainers = [ maintainers.moritzs ];
  };
}
