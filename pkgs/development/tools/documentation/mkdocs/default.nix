{ lib, python, fetchFromGitHub }:

with python.pkgs;

buildPythonApplication rec {
  pname = "mkdocs";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "mkdocs";
    repo = "mkdocs";
    rev = version;
    sha256 = "1x35vgiskgz4wwrvi4m1mri5wlphf15p90fr3rxsy5bf19v3s9hs";
  };

  checkInputs = [
    nose nose-exclude mock
  ];

  NOSE_EXCLUDE_TESTS = lib.concatStringsSep ";" [
    "mkdocs.tests.gh_deploy_tests.TestGitHubDeploy"
    "mkdocs.tests.config.config_tests.ConfigTests"
    "mkdocs.tests.config.config_options_tests.DirTest"
  ];

  checkPhase = "nosetests mkdocs";

  propagatedBuildInputs = [
    tornado
    livereload
    click
    pyyaml
    markdown
    jinja2
    backports_tempfile
  ];

  meta = {
    homepage = http://mkdocs.org/;
    description = "Project documentation with Markdown";
    license = lib.licenses.bsd2;
  };
}
