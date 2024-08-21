{
  buildGhidraExtension,
  fetchFromGitHub,
  gradle,
  ghidra-delinker-extension,
  lib,
}:
buildGhidraExtension rec {
  pname = "ghidra-delinker-extension";
  version = "0.5.0";
  src = fetchFromGitHub {
    owner = "boricj";
    repo = "ghidra-delinker-extension";
    rev = "v${version}";
    hash = "sha256-y0afqqIsWN33b/zGsxJYn8O+R5IP4eD300CgzMymEA0=";
  };
  prePatch = ''
    substituteInPlace build.gradle --replace-fail '"''${getGitHash()}"' '"v${version}"'
  '';
  mitmCache = gradle.fetchDeps {
    pkg = ghidra-delinker-extension;
    data = ./deps.json;
  };
  meta = {
    description = "Ghidra extension for exporting relocatable object files.";
    homepage = "https://github.com/boricj/ghidra-delinker-extension";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ roblabla ];
  };
}
