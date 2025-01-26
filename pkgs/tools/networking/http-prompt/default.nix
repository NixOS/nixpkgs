{
  lib,
  fetchFromGitHub,
  python3,
  httpie,
  versionCheckHook,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = _: super: {
      prompt-toolkit = super.prompt-toolkit.overridePythonAttrs (old: rec {
        version = "1.0.18";
        src = old.src.override {
          inherit version;
          hash = "sha256-3U/KAsgGlJetkxotCZFMaw0bUBUc6Ha8Fb3kx0cJASY=";
        };
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "http-prompt";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    tag = "v${version}";
    repo = "http-prompt";
    owner = "httpie";
    hash = "sha256-e4GyuxCeXYNsnBXyjIJz1HqSrqTGan0N3wxUFS+Hvkw=";
  };

  build-system = [ python.pkgs.setuptools ];

  dependencies = with python.pkgs; [
    click
    httpie
    parsimonious
    prompt-toolkit
    pygments
    six
    pyyaml
  ];

  pythonImportsCheck = [ "http_prompt" ];

  nativeCheckInputs = [
    python.pkgs.mock
    python.pkgs.pexpect
    python.pkgs.pytest-cov-stub
    python.pkgs.pytestCheckHook
    versionCheckHook
  ];

  disabledTests = [
    # require network access
    "test_get_and_tee"
    "test_get_image"
    "test_get_querystring"
    "test_post_form"
    "test_post_json"
    "test_spec_from_http"
    "test_spec_from_http_only"
    # executable path is hardcoded
    "test_help"
    "test_interaction"
    "test_version"
    "test_vi_mode"
  ];

  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Interactive command-line HTTP client featuring autocomplete and syntax highlighting";
    mainProgram = "http-prompt";
    homepage = "https://github.com/eliangcs/http-prompt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
