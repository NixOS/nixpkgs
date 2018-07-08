{ lib, python, fetchFromGitHub }:

with python.pkgs;

buildPythonApplication rec {
  pname = "mkdocs";
  version = "0.17.5";

  src = fetchFromGitHub {
    owner = "mkdocs";
    repo = "mkdocs";
    rev = version;
    sha256 = "1l1dahpwqikmww3yx2m6j2134npk8vcikg9klsmpqjpza8nigwzw";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "tornado>=4.1,<5.0" "tornado>=4.1"
  '';

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
