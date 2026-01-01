{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  hatch-vcs,
  hatchling,
  nodejs,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
=======
  fetchNpmDeps,
  hatch-vcs,
  hatchling,
  nodejs,
  npmHooks,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "yt-dlp-ejs";
<<<<<<< HEAD
  version = "0.3.2";
=======
  version = "0.3.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yt-dlp";
    repo = "ejs";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-o6qf4rfj42mCyvCBb+wyJmZKg3Q+ojsqbCcBfIJnTPg=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      ;
    fetcherVersion = 2;
    hash = "sha256-3hhwKUzfdlKmth4uRlfBSdxEOIfhAVaq2PZIOHWGWiM=";
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeBuildInputs = [
    nodejs
<<<<<<< HEAD
    pnpmConfigHook
    pnpm
  ];

  pythonImportsCheck = [ "yt_dlp_ejs" ];

=======
    npmHooks.npmConfigHook
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
