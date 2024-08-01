{ lib
, buildNpmPackage
, fetchFromGitHub
, testers
}:

let
  version = "2.2.12";
  src = fetchFromGitHub {
    owner = "immich-app";
    repo = "immich";
    # Using a fixed commit until upstream has release tags for cli.
    rev = "04340b3a6210dc7a00359e781815ee0b9cd1b8fd";
    hash = "sha256-PS1aZ6fcOudWlCFPuTeLBu3QrgUYnEuI5pBq3GGJ/bc=";
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

    npmDepsHash = "sha256-TRFN+xg8BdvzJKP1Y7GJsoRaWqdGoxS3qYx1OlhnOoY=";

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

    npmDepsHash = "sha256-rzjfGqYxrfGQHRCMiEpP229eSHCWVugMohQ/ZL1r1EQ=";

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
