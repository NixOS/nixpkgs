{ stdenv, buildPythonPackage, fetchPypi, coverage }:

buildPythonPackage rec {
  pname = "sh";
  version = "1.12.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z2hx357xp3v4cv44xmqp7lli3frndqpyfmpbxf7n76h7s1zaaxm";
  };

  checkInputs = [ coverage ];

  # A test needs the HOME directory to be different from $TMPDIR.
  preCheck = ''
    HOME=$(mktemp -d)
  '';

  meta = {
    description = "Python subprocess interface";
    homepage = https://pypi.python.org/pypi/sh/;
    license = stdenv.lib.licenses.mit;
  };
}
