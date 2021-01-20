{ lib
, fetchFromGitHub
, buildPythonPackage
, isPy27
, docopt
, easywatch
, jinja2
, pytestCheckHook
, markdown
}:

buildPythonPackage rec {
  pname = "staticjinja";
  version = "0.4.0";

  disabled = isPy27; # 0.4.0 drops python2 support

  # For some reason, in pypi the tests get disabled when using
  # PY_IGNORE_IMPORTMISMATCH, so we just fetch from GitHub
  src = fetchFromGitHub {
    owner = "staticjinja";
    repo = pname;
    rev = version;
    sha256 = "0pysk8pzmcg1nfxz8m4i6bvww71w2zg6xp33zgg5vrf8yd2dfx9i";
  };

  propagatedBuildInputs = [
    jinja2
    docopt
    easywatch
  ];

  checkInputs = [
    pytestCheckHook
    markdown
  ];

  # Import paths differ by a "build/lib" subdirectory, but the files are
  # the same, so we ignore import mismatches.
  preCheck = ''
    export PY_IGNORE_IMPORTMISMATCH=1
  '';

  meta = with lib; {
    description = "A library and cli tool that makes it easy to build static sites using Jinja2";
    homepage = "https://staticjinja.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
