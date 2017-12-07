{ lib
, python
}:

with python.pkgs;

buildPythonApplication rec {
  pname = "mycli";
  version = "1.6.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qg4b62kizyb16kk0cvpk70bfs3gg4q4hj2b15nnc7a3gqqfp67j";
  };

  propagatedBuildInputs = [
    pymysql configobj sqlparse prompt_toolkit pygments click pycrypto
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "==" ">="
  '';

  # No tests in archive. Newer versions do include tests
  doCheck = false;

  meta = {
    inherit version;
    description = "Command-line interface for MySQL";
    longDescription = ''
      Rich command-line interface for MySQL with auto-completion and
      syntax highlighting.
    '';
    homepage = http://mycli.net;
    license = lib.licenses.bsd3;
  };
}
