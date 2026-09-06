{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  deprecated-crypt-alternative,
  unittestCheckHook,
}:
buildPythonPackage rec {
  pname = "standard-crypt";
  version = "3.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "youknowone";
    repo = "python-deadlib";
    tag = "v${version}";
    hash = "sha256-vhGFTd1yXL4Frqli5D1GwOatwByDjvcP8sxgkdu6Jqg=";
  };

  sourceRoot = "${src.name}/crypt";

  build-system = [ setuptools ];

  dependencies = [ deprecated-crypt-alternative ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "python crypt module - removed from standard library in 3.13";
    homepage = "https://github.com/youknowone/python-deadlib";
    license = lib.licenses.psfl;
    maintainers = [ lib.maintainers.quantenzitrone ];
  };
}
