{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  nodejs,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
}:

buildPythonPackage rec {
  pname = "yt-dlp-ejs";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yt-dlp";
    repo = "ejs";
    tag = version;
    hash = "sha256-+tOA9sPk0BGJHFQCoAC8y5Bz3UcjgIPDQ8WDPkRlW5k=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      ;
    fetcherVersion = 2;
    hash = "sha256-3hhwKUzfdlKmth4uRlfBSdxEOIfhAVaq2PZIOHWGWiM=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  pythonImportsCheck = [ "yt_dlp_ejs" ];

  meta = {
    changelog = "https://github.com/yt-dlp/ejs/releases/tag/${version}";
    description = "External JavaScript for yt-dlp supporting many runtimes";
    homepage = "https://github.com/yt-dlp/ejs/";
    license = with lib.licenses; [
      unlicense
      mit
      isc
    ];
    maintainers = with lib.maintainers; [
      SuperSandro2000
      FlameFlag
    ];
  };
}
