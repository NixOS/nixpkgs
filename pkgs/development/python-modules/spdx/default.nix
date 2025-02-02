{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "spdx";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "bbqsrc";
    repo = "spdx-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-lfTgAX4Wl01xrvLA12ZUqjah7ZiLafMAU+yNNdVkRk0=";
  };

  pythonImportsCheck = [ "spdx" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SPDX license list database";
    homepage = "https://github.com/bbqsrc/spdx-python";
    changelog = "https://github.com/bbqsrc/spdx-python/releases/tag/v${version}";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}
