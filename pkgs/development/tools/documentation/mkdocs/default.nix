{ lib
, python3
, fetchFromGitHub
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "mkdocs";
  disabled = pythonOlder "3.6";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "09fh7byadm81vddw9k9b9gq8pz8f0c9jjs65jmnlysinsawaw4y1";
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

  pythonImportsCheck = [ "mkdocs" ];

  doCheck = false;
  # tests mirgated to tox

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
