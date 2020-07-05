{ lib
, python3
, glibcLocales
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "mycli";
  version = "1.21.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q9p0yik9cpvpxjs048anvhicfcna84mpl7axv9bwgr48w40lqwg";
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

  # TODO: remove with next release
  postPatch = ''
    substituteInPlace setup.py \
      --replace "prompt_toolkit>=2.0.6,<3.0.0" "prompt_toolkit"
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
