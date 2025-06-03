{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "sharp-aquos-rc";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jmoore987";
    repo = "sharp_aquos_rc";
    tag = version;
    hash = "sha256-w/XA58iT/pmNCy9up5fayjxBsevzgr8ImKgPiNtYHAM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ pyyaml ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "sharp_aquos_rc" ];

  meta = with lib; {
    homepage = "https://github.com/jmoore987/sharp_aquos_rc";
    description = "Control Sharp Aquos SmartTVs through the IP interface";
    changelog = "https://github.com/jmoore987/sharp_aquos_rc/releases/tag/${version}";
    maintainers = with maintainers; [ jamiemagee ];
    license = licenses.mit;
  };
}
