{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "thorlabspm100";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clade";
    repo = "ThorlabsPM100";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X4qEow6u4aE0sbFwZfK3YEso2RS0c9j4iaWJPHaPQV4=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ThorlabsPM100" ];

  meta = {
    description = "Interface to the PM100A/D power meter from Thorlabs";
    homepage = "https://github.com/clade/ThorlabsPM100/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fsagbuya ];
  };
})
