{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  htmltools,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "shinychat";
  version = "0.2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "shinychat";
    tag = "py/v${version}";
    hash = "sha256-thdLaZ+rnD8yumxhjXOLhufcSBD0oNKOWSxxDdJ9tNU=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    htmltools
  ];

  pythonRemoveDeps = [ "shiny" ];

  pythonImportsCheck = [ "shinychat" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Chat UI component for Shiny for Python";
    homepage = "https://posit-dev.github.io/shinychat";
    changelog = "https://github.com/posit-dev/shinychat/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
