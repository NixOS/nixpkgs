{
  lib,
  buildPythonPackage,
  cffi,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  six,
  ssdeep,
}:

buildPythonPackage (finalAttrs: {
  pname = "ssdeep";
  version = "3.4.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DinoTools";
    repo = "python-ssdeep";
    tag = finalAttrs.version;
    hash = "sha256-I5ci5BS+B3OE0xdLSahu3HCh99jjhnRHJFz830SvFpg=";
  };

  buildInputs = [ ssdeep ];

  build-system = [ setuptools ];

  dependencies = [
    cffi
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  pythonImportsCheck = [ "ssdeep" ];

  meta = {
    description = "Python wrapper for the ssdeep library";
    homepage = "https://github.com/DinoTools/python-ssdeep";
    changelog = "https://github.com/DinoTools/python-ssdeep/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
