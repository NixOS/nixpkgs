{ buildNpmPackage
, darwin
, fetchFromGitHub
, lib
, python3
, stdenv
}:

buildNpmPackage rec {
  pname = "nest-cli";
  version = "10.3.2";

  src = fetchFromGitHub {
    owner = "nestjs";
    repo = pname;
    rev = version;
    hash = "sha256-FSI87oeHiNqL8FhGavPtqurOr/1Y5iGawSwhBhLB2Ls=";
  };

  npmDepsHash = "sha256-RqotLpMISfB2xE9zng0TkapJ0y1fuVWP/0nY2VcMVRU=";

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
  };
}
