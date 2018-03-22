{ lib, python, fetchFromGitHub }:

with python.pkgs;

buildPythonApplication rec {
  pname = "mkdocs";
  version = "0.17.3";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "mkdocs";
    repo = "mkdocs";
    rev = version;
    sha256 = "15lv60gdc837zja5kn2rfp78kwyb1ckc43jg01zfzqra4qz7b6rw";
  };

  checkInputs = [
    nose nose-exclude mock
  ];

  NOSE_EXCLUDE_TESTS="mkdocs.tests.gh_deploy_tests.TestGitHubDeploy;mkdocs.tests.config.config_tests.ConfigTests";

  checkPhase = "nosetests mkdocs";

  propagatedBuildInputs = [
    tornado
    livereload
    click
    pyyaml
    markdown
    jinja2
  ];

  meta = {
    homepage = http://mkdocs.org/;
    description = "Project documentation with Markdown";
    license = lib.licenses.bsd2;
  };
}
