{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  nodejs,
  pnpm,
}:

buildPythonPackage rec {
  pname = "yt-dlp-ejs";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yt-dlp";
    repo = "ejs";
    rev = "4f1d91dbb11a49c1b666609ff2119753191fd875";
    hash = "sha256-p1jWAALPNfhjiJV6NOWvV8VZ5w8p7eZsTc9JApiq0DM=";
  };

  patches = [
    ./pnpm-cmd.patch
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit
      pname
      version
      src
      patches
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
    pnpm.configHook
  ];

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
