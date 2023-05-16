{ buildNpmPackage
<<<<<<< HEAD
, darwin
, fetchFromGitHub
, lib
, python3
, stdenv
=======
, fetchFromGitHub
, lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildNpmPackage rec {
  pname = "nest-cli";
<<<<<<< HEAD
  version = "10.1.17";
=======
  version = "9.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nestjs";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-03GDrKjlvl3O3kJlbbyDYxtlfwLkZbvxC9gvP534zSY=";
  };

  npmDepsHash = "sha256-nZ9ant2c+15bRBikFcKZW8aiFqI3WC6hktSiBfnma/I=";

  env = {
    npm_config_build_from_source = true;
  };

  nativeBuildInputs = [
    python3
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "CLI tool for Nest applications";
    homepage = "https://nestjs.com";
    license = licenses.mit;
    mainProgram = "nest";
    maintainers = [ maintainers.ehllie ];
    broken = stdenv.isDarwin; # https://github.com/nestjs/nest-cli/pull/2281
=======
    hash = "sha256-9I6ez75byOPVKvX93Yv1qSM3JaWlmmvZCTjNB++cmw0=";
  };

  # Generated a new package-lock.json by running `npm upgrade`
  # The upstream lockfile is using an old version of `fsevents`,
  # which does not build on Darwin
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  npmDepsHash = "sha256-QA2ZgbXiG84HuutJ2ZCGMrnqpwrPlHL/Bur7Pak8WcQ=";

  meta = with lib; {
    description = "CLI tool for Nest applications 🍹";
    homepage = "https://nestjs.com";
    license = licenses.mit;
    maintainers = [ maintainers.ehllie ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
