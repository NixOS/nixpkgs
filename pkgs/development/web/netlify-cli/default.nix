{
  callPackage,
  vips,
  pkg-config,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "netlify-cli";
  version = "17.37.2";

  src = fetchFromGitHub {
    owner = "netlify";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-1UaIPCzyHMKNJfDFILPYIrjHwzHAmlYNk+aHZM1Bp6Q=";
  };

  npmDepsHash = "sha256-pJaNdR9jyFSdfE+yLnQn9/Gbq2CbH6y3aEVbpg3Ft/o=";

  buildInputs = [ vips ];
  nativeBuildInputs = [ pkg-config ];

  passthru = {
    tests.test = callPackage ./test.nix { };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Netlify command line tool";
    homepage = "https://github.com/netlify/cli";
    changelog = "https://github.com/netlify/cli/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ roberth ];
    mainProgram = "netlify";
  };
}
