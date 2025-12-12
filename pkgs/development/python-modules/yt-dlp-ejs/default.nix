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
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yt-dlp";
    repo = "ejs";
    tag = version;
    hash = "sha256-o6qf4rfj42mCyvCBb+wyJmZKg3Q+ojsqbCcBfIJnTPg=";
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
