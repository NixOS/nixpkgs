{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon {
  pname = "yomichan-forvo-server";
  version = "0-unstable-2024-10-21";
  src = fetchFromGitHub {
    owner = "jamesnicolas";
    repo = "yomichan-forvo-server";
    rev = "364fc6d5d10969f516e0fa283460dfaf08c98e15";
    hash = "sha256-Jpee9hkXCiBmSW7hzJ1rAg45XVIiLC8WENc09+ySFVI=";
  };
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };
  meta = {
    description = "Audio server for yomichan that scrapes forvo for audio files";
    homepage = "https://github.com/jamesnicolas/yomichan-forvo-server";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ junestepp ];
  };
}
