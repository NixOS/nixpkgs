{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  gitUpdater,
}:

buildFishPlugin rec {
  pname = "editor-updater";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dudeofawesome";
    repo = "fish-plugin-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-cS95OGrq0u9/VS19wTpzx/d8nMZqzxZt7Lzj0M/9Yp0=";
  };

  meta = {
    description = "Fish shell plugin to set EDITOR in an IDE's integrated terminal";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dudeofawesome ];
  };

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };
}
