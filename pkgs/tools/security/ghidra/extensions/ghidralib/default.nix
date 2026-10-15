{
  lib,
  fetchFromGitHub,
  buildGhidraScripts,
}:
buildGhidraScripts {
  pname = "GhidraLib";
  version = "0.2.0-unstable-2025-10-31";

  src = fetchFromGitHub {
    owner = "msm-code";
    repo = "ghidralib";
    rev = "f3e33e444b4a8682c240c87f8754542e2e338731";
    hash = "sha256-Dz7CWHkszHq5HT/S9cBGOfkoamnf9T1l2IbaAZXEGf0=";
  };

  meta = {
    description = "A Pythonic Ghidra standard library";
    homepage = "https://github.com/msm-code/ghidralib";
    maintainers = with lib.maintainers; [
      BonusPlay
      msm
    ];
    license = lib.licenses.asl20;
  };
}
