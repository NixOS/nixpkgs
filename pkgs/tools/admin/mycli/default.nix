{ lib
, python3
, glibcLocales
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "mycli";
  version = "1.26.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jAMDXJtFJtv6CwhZZU4pdKDndZKp6bJ/QPWo2q6DvrE=";
  };

  propagatedBuildInputs = [
    cli-helpers
    click
    configobj
    importlib-resources
    paramiko
    prompt-toolkit
    pyaes
    pycrypto
    pygments
    pymysql
    pyperclip
    sqlglot
    sqlparse
  ];

  nativeCheckInputs = [ pytest glibcLocales ];

  checkPhase = ''
    export HOME=.
    export LC_ALL="en_US.UTF-8"

    py.test \
      --ignore=mycli/packages/paramiko_stub/__init__.py
  '';

  postPatch = ''
    substituteInPlace setup.py \
      --replace "cryptography == 36.0.2" "cryptography"
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
