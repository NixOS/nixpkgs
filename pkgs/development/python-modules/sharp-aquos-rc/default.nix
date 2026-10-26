{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "sharp-aquos-rc";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jmoore987";
    repo = "sharp_aquos_rc";
    tag = finalAttrs.version;
    hash = "sha256-w/XA58iT/pmNCy9up5fayjxBsevzgr8ImKgPiNtYHAM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ pyyaml ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "sharp_aquos_rc" ];

  meta = {
    homepage = "https://github.com/jmoore987/sharp_aquos_rc";
    description = "Control Sharp Aquos SmartTVs through the IP interface";
    changelog = "https://github.com/jmoore987/sharp_aquos_rc/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ jamiemagee ];
    license = lib.licenses.mit;
  };
})
