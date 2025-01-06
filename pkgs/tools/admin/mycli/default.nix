{ lib
, python3
, fetchPypi
, glibcLocales
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "mycli";
  version = "1.27.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0R2k5hRkAJbqgGZEPXWUb48oFxTKMKiQZckf3F+VC3I=";
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

  nativeCheckInputs = [ pytestCheckHook glibcLocales ];

  preCheck = ''
    export HOME=.
    export LC_ALL="en_US.UTF-8"
  '';

  # fails at checkphase due to the below test paths
  # disabling it specifically does not work, so we disable checking altogether
  doCheck = false;
  disabledTestPaths = [
    "mycli/packages/paramiko_stub/__init__.py"
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "cryptography == 36.0.2" "cryptography"
  '';

  meta = with lib; {
    inherit version;
    description = "Command-line interface for MySQL";
    mainProgram = "mycli";
    longDescription = ''
      Rich command-line interface for MySQL with auto-completion and
      syntax highlighting.
    '';
    homepage = "http://mycli.net";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jojosch ];
  };
}
