{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  hatch-vcs,
  hatchling,
  nodejs,
  npmHooks,
}:

buildPythonPackage rec {
  pname = "yt-dlp-ejs";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yt-dlp";
    repo = "ejs";
    tag = version;
    hash = "sha256-PoZ7qmrf8en254im2D7fWy9jYiaJwFpq6ZXZP9ouOOQ=";
  };

  postPatch = ''
    # remove when upstream has a lock file we support https://github.com/yt-dlp/ejs/issues/29
    cp ${./package-lock.json} package-lock.json

    # we already ran npm install
    substituteInPlace hatch_build.py \
      --replace-fail 'subprocess.run(["npm", "install"], check=True, shell=requires_shell)' ""
  '';

  npmDeps = fetchNpmDeps {
    inherit src postPatch;
    hash = "sha256-2Xzetr2pb8J2w+ghfoTVP6oZTeVbHV7EcovwxElnUbA=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
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
