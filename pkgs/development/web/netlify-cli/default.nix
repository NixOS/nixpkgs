{
  buildNpmPackage,
  callPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  nodejs,
  pkg-config,
  vips,
}:

buildNpmPackage rec {
  pname = "netlify-cli";
  version = "17.38.0";

  src = fetchFromGitHub {
    owner = "netlify";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-fK+Z6bqnaqSYXgO0lUbGALZeCiAnvMd6LkMSH7JB7J8=";
  };

  npmDepsHash = "sha256-oFt+l8CigOtm3W5kiT0kFsqKLOJB9ggfiFQgUU5xQ1I=";

  inherit nodejs;

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
