{
  lib,
  python3,
  fetchFromGitHub,
  nixosTests,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pinnwand";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supakeen";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-oB7Dd1iVzGqr+5nG7BfZuwOQUgUnmg6ptQDZPGH7P5E=";
  };

  build-system = with python3.pkgs; [ pdm-pep517 ];

  dependencies = with python3.pkgs; [
    click
    docutils
    pygments
    pygments-better-html
    python-dotenv
    sqlalchemy
    token-bucket
    tomli
    tornado
  ];

  nativeCheckInputs = with python3.pkgs; [
    gitpython
    pytest-asyncio
    pytest-cov-stub
    pytest-html
    pytest-playwright
    pytestCheckHook
    toml
    urllib3
  ];

  disabledTestPaths = [
    # out-of-date browser tests
    "test/e2e"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = nixosTests.pinnwand;

  meta = {
    changelog = "https://github.com/supakeen/pinnwand/releases/tag/v${version}";
    description = "Python pastebin that tries to keep it simple";
    homepage = "https://github.com/supakeen/pinnwand";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.hexa ];
    mainProgram = "pinnwand";
    platforms = lib.platforms.linux;
  };
}
