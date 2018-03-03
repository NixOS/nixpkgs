{ lib, python, fetchFromGitHub }:

with python.pkgs;

buildPythonApplication rec {
  pname = "mkdocs";
  version = "0.17.2";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "mkdocs";
    repo = "mkdocs";
    rev = version;
    sha256 = "0hpjs9qj0nr57a249yv8xvl61d3d2rrdfqxp1fm28z77l2xjj772";
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
