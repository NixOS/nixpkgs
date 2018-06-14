{ lib, python, fetchFromGitHub }:

with python.pkgs;

buildPythonApplication rec {
  pname = "mkdocs";
  version = "0.17.4";

  src = fetchFromGitHub {
    owner = "mkdocs";
    repo = "mkdocs";
    rev = version;
    sha256 = "1hwvy6lnqqmzjia5vqd45jx6gwd9cvf7p5vw245c0cg27zkgpazp";
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
