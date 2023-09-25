{ lib
, stdenv
, fetchFromGitHub
, buildNpmPackage
, git
, python3
, darwin
, krb5
, libmongocrypt
, testers
, mongosh
}:

buildNpmPackage rec {
  pname = "mongosh";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "mongodb-js";
    repo = "mongosh";
    rev = "v${version}";
    hash = "sha256-W8NGoT/kNFjEElQraEg96OqlNtESsdD8WP+aWp6autg=";
  };

  # lerna ERR! ENOGIT The git binary was not found, or this is not a git repository.
  postPatch = ''
    if [ -x "$(command -v git)" ]; then
      export HOME="$(mktemp -d)"
      git config --global user.name "Nix Builder"
      git config --global user.email "nix-builder@nixos.org"
      git config --global init.defaultBranch "main"
      git init .
    fi
  '';

  npmDepsHash = "sha256-xiBIlNuZfu/5UOa6IAh1qT7rbrR/LG4N6qj2MZpjI0o=";

  nativeBuildInputs = [
    git
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.cctools
  ];

  buildInputs = [
    krb5
    libmongocrypt
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    # error: no such file or directory: '.../lib/libmongocrypt-static.a'
    BUILD_TYPE = "dynamic";
    # ERROR: Failed to set up Chrome r...! Set "PUPPETEER_SKIP_DOWNLOAD" env variable to skip download.
    PUPPETEER_SKIP_DOWNLOAD = true;
    # Error: Segment key is required
    SEGMENT_API_KEY = "dummy";
  };

  npmBuildScript = "compile-cli";

  preInstall = ''
    sed -i '3i  "version": "${version}",' package.json
  '';

  postFixup = ''
    substituteInPlace $out/lib/node_modules/mongosh/packages/cli-repl/package.json \
      --replace "0.0.0-dev.0" "${version}"
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = mongosh;
    };
  };

  meta = with lib; {
    homepage = "https://www.mongodb.com/try/download/shell";
    description = "The MongoDB Shell";
    maintainers = with maintainers; [ aaronjheng ];
    license = licenses.asl20;
    mainProgram = "mongosh";
  };
}
