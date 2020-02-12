{ stdenv, lib, python3, fetchFromGitHub }:

with python3.pkgs;

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

  meta = with stdenv.lib; {
    description = "Project documentation with Markdown / static website generator";
    longDescription = ''
      MkDocs is a fast, simple and downright gorgeous static site generator that's
      geared towards building project documentation. Documentation source files
      are written in Markdown, and configured with a single YAML configuration file.
      
      MkDocs can also be used to generate general-purpose Websites.
    '';
    homepage = http://mkdocs.org/;
    license = lib.licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.rkoe ];
  };
}
