{ lib
, python3
, glibcLocales
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "mycli";
  version = "1.20.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vhwaqkx4njarm0wy8zg2hvzr2yl92y8gnwipcn7p59sazw4whfl";
  };

  propagatedBuildInputs = [
    paramiko pymysql configobj sqlparse prompt_toolkit pygments click pycrypto cli-helpers
  ];

  checkInputs = [ pytest mock glibcLocales ];

  checkPhase = ''
    export HOME=.
    export LC_ALL="en_US.UTF-8"

    py.test
  '';

  meta = {
    inherit version;
    description = "Command-line interface for MySQL";
    longDescription = ''
      Rich command-line interface for MySQL with auto-completion and
      syntax highlighting.
    '';
    homepage = http://mycli.net;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.jojosch ];
  };
}
