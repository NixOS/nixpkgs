{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildFishPlugin rec {
  pname = "osx";
  version = "0-unstable-2019-01-14";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-${pname}";
    rev = "27039b251201ec2e70d8e8052cbc59fa0ac3b3cd";
    hash = "sha256-jSUIk3ewM6QnfoAtp16l96N1TlX6vR0d99dvEH53Xgw=";
  };

  meta = {
    inherit (src.meta) homepage;
    description = "Integration with macOS Finder, iTunes, and more";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dudeofawesome ];
  };

  passthru = {
    updateScript = unstableGitUpdater { };
  };
}
