{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  click,
  help2man,
  markdown-it-py,
  shtab,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "setuptools-generate";
  version = "0.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Freed-Wu";
    repo = "setuptools-generate";
    tag = version;
    hash = "sha256-xDjxkWy/n0jStI9eLcM6WduyU9vGjtBOmJ86dpXjceQ=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    click
    help2man
    markdown-it-py
    shtab
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "setuptools_generate" ];

  meta = {
    description = "Generate shell completions and man page when building a python package";
    homepage = "https://github.com/Freed-Wu/setuptools-generate";
    changelog = "https://github.com/Freed-Wu/setuptools-generate/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
