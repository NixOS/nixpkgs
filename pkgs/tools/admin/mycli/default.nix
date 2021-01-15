{ lib
, python3
, glibcLocales
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "mycli";
  version = "1.23.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-k1UHpEoszThUvoL4h59vGZ71bAx26VJ0iT/YuVQk/Lk=";
  };

  propagatedBuildInputs = [
    cli-helpers
    click
    configobj
    paramiko
    prompt_toolkit
    pycrypto
    pygments
    pymysql
    pyperclip
    sqlparse
  ];

  checkInputs = [ pytest mock glibcLocales ];

  checkPhase = ''
    export HOME=.
    export LC_ALL="en_US.UTF-8"

    py.test \
      --ignore=mycli/packages/paramiko_stub/__init__.py
  '';

  postPatch = ''
    substituteInPlace setup.py \
      --replace "sqlparse>=0.3.0,<0.4.0" "sqlparse"
  '';

  meta = with lib; {
    inherit version;
    description = "Command-line interface for MySQL";
    longDescription = ''
      Rich command-line interface for MySQL with auto-completion and
      syntax highlighting.
    '';
    homepage = "http://mycli.net";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jojosch ];
  };
}
