{buildPythonPackage, lib, nose, fetchPypi}:

buildPythonPackage rec {
  pname = "titlecase";
  name = "${pname}-${version}";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0486i99wf8ssa7sgn81fn6fv6i4rhhq6n751bc740b3hzfbpmpl4";
  };

  checkInputs = [ nose ];

  meta = {
    homepage = https://github.com/ppannuto/python-titlecase;
    description = "Python Port of John Gruber's titlecase.pl";
    license = lib.licenses.mit;
  };
}

