{ buildNpmPackage
, darwin
, fetchFromGitHub
, lib
, python3
, stdenv
}:

buildNpmPackage rec {
  pname = "nest-cli";
  version = "10.1.17";

  src = fetchFromGitHub {
    owner = "nestjs";
    repo = pname;
    rev = version;
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
  };
}
