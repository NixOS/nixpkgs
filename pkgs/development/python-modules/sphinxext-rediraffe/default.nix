{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  sphinx,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sphinxext-rediraffe";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wpilibsuite";
    repo = "sphinxext-rediraffe";
    tag = "v${version}";
    hash = "sha256-OW+MNQbPfJa8+jcpWZxTKD+EAv1gyo5tmcYAGba4u3c=";
  };

  postPatch = ''
    # Fixes "packaging.version.InvalidVersion: Invalid version: 'main'"
    substituteInPlace setup.py \
      --replace-fail 'version = "main"' 'version = "${version}"'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    sphinx
  ];

  # tests require seleniumbase which is not currently in nixpkgs
  doCheck = false;

  pythonImportsCheck = [ "sphinxext.rediraffe" ];

  pythonNamespaces = [ "sphinxext" ];

  meta = {
    description = "Sphinx extension to redirect files";
    homepage = "https://github.com/wpilibsuite/sphinxext-rediraffe";
    changelog = "https://github.com/wpilibsuite/sphinxext-rediraffe/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.newam ];
  };
}
