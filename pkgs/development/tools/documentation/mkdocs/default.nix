{ lib, python, fetchFromGitHub }:

with python.pkgs;

buildPythonApplication rec {
  pname = "mkdocs";
  version = "0.16.3";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "mkdocs";
    repo = "mkdocs";
    rev = version;
    sha256 = "0gssa5gbd1y2v3azdhf2zh7ayx4ncfag4r2a6fi96jbic64r3qrs";
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
