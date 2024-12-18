{ lib
, buildNpmPackage
, fetchFromGitHub
, testers
}:

let
  version = "2.2.4";
  src = fetchFromGitHub {
    owner = "immich-app";
    repo = "immich";
    # Using a fixed commit until upstream has release tags for cli.
    rev = "8c2195c8205156f6e3168cc52fa34db334568ea9";
    hash = "sha256-Tseu6aIrYU4Af/jWDi2wDtP77n/aogp7Qkn9mosMaes=";
  };
  meta' = {
    description = "CLI utilities for Immich to help upload images and videos";
    homepage = "https://github.com/immich-app/immich";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felschr pineapplehunter ];
    mainProgram = "immich";
  };

  open-api-typescript-sdk = buildNpmPackage {
    pname = "immich-cli-openapi-typescript-sdk";
    inherit src version;

    npmDepsHash = "sha256-WhNdFaFBwb6ehEQgbNJGdzPb3FdJk1Nefi8DcJfY9Wc=";

    postPatch = ''
      cd open-api/typescript-sdk
    '';
    meta = {
      # using inherit for `builtin.unsafeGetAttrPos` to work correctly
      inherit (meta')
        description
        homepage
        license
        maintainers;
    };
  };

  immich-cli = buildNpmPackage {
    pname = "immich-cli";
    inherit src version;

    npmDepsHash = "sha256-aSTN+I8B/aLT2ItGoyZTlbdn1VCK0ZmOb1QG7ZQuz+Q=";

    postPatch = ''
      ln -sv ${open-api-typescript-sdk}/lib/node_modules/@immich/sdk/{build,node_modules} open-api/typescript-sdk
      cd cli
    '';

    passthru = {
      inherit open-api-typescript-sdk;
      tests.version = testers.testVersion { package = immich-cli; };
    };

    meta = {
      # using inherit for `builtin.unsafeGetAttrPos` to work correctly
      inherit (meta')
        description
        homepage
        license
        maintainers
        mainProgram;
    };
  };
in
immich-cli
