{ lib
, python3
, glibcLocales
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "mycli";
  version = "1.25.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/vEu2BJf0T7fSgSXflq56Ilaih7RAhhilZUgbNzZYQg=";
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
    sqlparse
  ];

  checkInputs = [ pytest glibcLocales ];

  checkPhase = ''
    export HOME=.
    export LC_ALL="en_US.UTF-8"

    py.test \
      --ignore=mycli/packages/paramiko_stub/__init__.py
  '';

  postPatch = ''
    substituteInPlace setup.py \
      --replace "sqlparse>=0.3.0,<0.4.0" "sqlparse" \
      --replace "importlib_resources >= 5.0.0" "importlib_resources"
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
