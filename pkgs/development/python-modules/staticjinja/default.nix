{ lib
, fetchFromGitHub
, buildPythonPackage
, isPy27
, docopt
, easywatch
, jinja2
, pytestCheckHook
, pytest-check
, fetchPypi
, markdown
, sphinx
, sphinx_rtd_theme
}:

buildPythonPackage rec {
  pname = "staticjinja";
  version = "1.0.3";

  disabled = isPy27; # 0.4.0 drops python2 support

  # For some reason, in pypi the tests get disabled when using
  # PY_IGNORE_IMPORTMISMATCH, so we just fetch from GitHub
  src = fetchFromGitHub {
    owner = "staticjinja";
    repo = pname;
    rev = version;
    sha256 = "12rpv5gv64i5j4w98wm1444xnnmarcn3pg783j3fkkzc58lk5wwj";
  };

  propagatedBuildInputs = [
    jinja2
    docopt
    easywatch
  ];

  checkInputs = [
    pytestCheckHook
    pytest-check
    markdown
    sphinx_rtd_theme
    sphinx
  ];

  preCheck = ''
    # Import paths differ by a "build/lib" subdirectory, but the files are
    # the same, so we ignore import mismatches.
    export PY_IGNORE_IMPORTMISMATCH=1
    # The tests need to find and call the installed staticjinja executable
    export PATH="$PATH:$out/bin";
  '';

  meta = with lib; {
    description = "A library and cli tool that makes it easy to build static sites using Jinja2";
    homepage = "https://staticjinja.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
