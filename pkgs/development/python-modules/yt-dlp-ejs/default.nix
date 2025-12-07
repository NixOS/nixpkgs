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
    rev = "3e76dde15323725c7bb0e31ef78a8964156142ce";
    hash = "sha256-lyQyZo9Hbb03Hp8A7e5emR7Yz5hic3UaOyYOXRCFcio=";
  };

  pnpmDeps = pnpm.fetchDeps {
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
