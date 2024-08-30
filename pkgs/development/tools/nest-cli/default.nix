{ buildNpmPackage
, darwin
, fetchFromGitHub
, lib
, python3
, stdenv
}:

buildNpmPackage rec {
  pname = "nest-cli";
  version = "10.4.5";

  src = fetchFromGitHub {
    owner = "nestjs";
    repo = pname;
    rev = version;
    hash = "sha256-F/Oi7ra+UE4YKXHZalH5qFk4coaGfHRpWaxamYunRuw=";
  };

  npmDepsHash = "sha256-6yh8TKfq3fuq4QcnA4uM49/G0Kp1sccRyTcV5s9dVck=";

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
