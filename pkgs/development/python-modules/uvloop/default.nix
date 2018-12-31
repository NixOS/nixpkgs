{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, pkgs
}:

buildPythonPackage rec {
  pname   = "uvloop";
  version = "0.11.3";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1apis7yw1i78w8liigzj3kiwv4gb3xqzg4111qnvj1zalb844l7x";
  };

  buildInputs = [ pkgs.libuv ];
  setupPyBuildFlags = [ "--use-system-libuv" ];

  # tests seem to trigger some failure in the sandbox due to pipe requirements,
  # and also requirements on e.g. psutils
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python interface for libuv";
    homepage    = https://github.com/saghul/pyuv;
    license     = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
