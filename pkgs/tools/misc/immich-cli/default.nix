{ lib
, buildNpmPackage
, fetchFromGitHub
, testers
}:

let
  version = "2.2.15";
  src = fetchFromGitHub {
    owner = "immich-app";
    repo = "immich";
    # Using a fixed commit until upstream has release tags for cli.
    rev = "f7bfde6a3286d4b454c2f05ccf354914f8eccac6";
    hash = "sha256-O014Y2HwhfPqKKFFGtNDJBzCaR6ugI4azw6/kfzKET0=";
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

    npmDepsHash = "sha256-rIN88xw8kdLfhFbT4OReTwzWqNlD4QVAAuvfMyda+V8=";

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

    npmDepsHash = "sha256-r/kCE6FmhbnMVv2Z76hH/1O1YEYSq9VY5kB0xlqWzaM=";

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
