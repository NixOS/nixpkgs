{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin rec {
  pname = "macos";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "halostatue";
    repo = "fish-macos";
    tag = "v${version}";
    hash = "sha256-o5VBeoA62KRDcnJXdXzllF1FMaSLMW1rxhaRC4rzWrg=";
  };

  meta = {
    description = "MacOS functions for Fish";
    homepage = "https://github.com/halostatue/fish-macos";
    changelog = "https://github.com/halostatue/fish-macos/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.samasaur ];
  };
}
