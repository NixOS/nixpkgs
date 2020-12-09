{ lib
, python3
, glibcLocales
, fetchpatch
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

  patches = [
    # TODO: remove with next release (v1.22.3 or v1.23)
    (fetchpatch {
      url = "https://github.com/dbcli/mycli/commit/17f093d7b70ab2d9f3c6eababa041bf76f029aac.patch";
      sha256 = "sha256-VwfbtzUtElV+ErH+NJb+3pRtSaF0yVK8gEWCvlzZNHI=";
      excludes = [ "changelog.md" "mycli/AUTHORS" ];
    })
  ];

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
