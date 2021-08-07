{ lib
, python3
, fetchFromGitHub
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "mkdocs";
  version = "1.2.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-JF3Zz1ObxeKsIF0pa8duJxqjLgMvmWsWMApHT43Z+EY=";
  };

  propagatedBuildInputs = [
    click
    jinja2
    markdown
    mergedeep
    pyyaml
    pyyaml-env-tag
    ghp-import
    importlib-metadata
    watchdog
    packaging
  ];

  checkInputs = [
    Babel
    mock
    pytestCheckHook
  ];

  postPatch = ''
    # Remove test due to missing requirement
    rm mkdocs/tests/theme_tests.py
  '';

  pytestFlagsArray = [ "mkdocs/tests/*.py" ];

  disabledTests = [
    # Don't start a test server
    "testing_server"
  ];

  pythonImportsCheck = [ "mkdocs" ];

  meta = with lib; {
    description = "Project documentation with Markdown / static website generator";
    longDescription = ''
      MkDocs is a fast, simple and downright gorgeous static site generator that's
      geared towards building project documentation. Documentation source files
      are written in Markdown, and configured with a single YAML configuration file.

      MkDocs can also be used to generate general-purpose websites.
    '';
    homepage = "http://mkdocs.org/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ rkoe ];
  };
}
