{ lib
, python3
, glibcLocales
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "mycli";
  version = "1.22.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lq2x95553vdmhw13cxcgsd2g2i32izhsb7hxd4m1iwf9b3msbpv";
  };

  propagatedBuildInputs = [
    paramiko pymysql configobj sqlparse prompt_toolkit pygments click pycrypto cli-helpers
  ];

  checkInputs = [ pytest mock glibcLocales ];

  checkPhase = ''
    export HOME=.
    export LC_ALL="en_US.UTF-8"

    py.test \
      --ignore=mycli/packages/paramiko_stub/__init__.py
  '';

  meta = {
    inherit version;
    description = "Command-line interface for MySQL";
    longDescription = ''
      Rich command-line interface for MySQL with auto-completion and
      syntax highlighting.
    '';
    homepage = "http://mycli.net";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.jojosch ];
  };
}
