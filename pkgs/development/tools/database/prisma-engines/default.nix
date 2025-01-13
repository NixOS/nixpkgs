{ fetchFromGitHub
, lib
, Security
, openssl
, pkg-config
, protobuf
, rustPlatform
, stdenv
}:

# Updating this package will force an update for prisma. The
# version of prisma-engines and prisma must be the same for them to
# function correctly.
rustPlatform.buildRustPackage rec {
  pname = "prisma-engines";
  version = "5.21.0";

  src = fetchFromGitHub {
    owner = "prisma";
    repo = "prisma-engines";
    rev = version;
    hash = "sha256-X5aBrnyZ/tMykJFifyY1LeR/nShBlxm9HazVE0L7RJk=";
  };

  # Use system openssl.
  OPENSSL_NO_VENDOR = 1;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "barrel-0.6.6-alpha.0" = "sha256-USh0lQ1z+3Spgc69bRFySUzhuY79qprLlEExTmYWFN8=";
      "cuid-1.3.2" = "sha256-qBu1k/dJiA6rWBwk4nOOqouIneD9h2TTBT8tvs0TDfA=";
      "graphql-parser-0.3.0" = "sha256-0ZAsj2mW6fCLhwTETucjbu4rPNzfbNiHu2wVTBlTNe4=";
      "mysql_async-0.31.3" = "sha256-2wOupQ/LFV9pUifqBLwTvA0tySv+XWbxHiqs7iTzvvg=";
      "postgres-native-tls-0.5.0" = "sha256-4CftieImsG2mBqpoJFfyq0R2yd2EyQX4oddAwyXMDZc=";
      "mongodb-3.0.0" = "sha256-1WQgY0zSZhFjt1nrLYTUBrpqBxpCCgKRSeGJLtkE6pw=";
    };
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    protobuf
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  # FIXME: fix this upstream and remove this patch with the next version update.
  postPatch = ''
    file=libs/user-facing-errors/src/schema_engine.rs
    echo "#![allow(dead_code)]" | cat - $file > $file.new
    mv $file.new $file
  '';

  preBuild = ''
    export OPENSSL_DIR=${lib.getDev openssl}
    export OPENSSL_LIB_DIR=${lib.getLib openssl}/lib

    export PROTOC=${protobuf}/bin/protoc
    export PROTOC_INCLUDE="${protobuf}/include";

    export SQLITE_MAX_VARIABLE_NUMBER=250000
    export SQLITE_MAX_EXPR_DEPTH=10000

    export GIT_HASH=0000000000000000000000000000000000000000
  '';

  cargoBuildFlags = [
    "-p" "query-engine"
    "-p" "query-engine-node-api"
    "-p" "schema-engine-cli"
    "-p" "prisma-fmt"
  ];

  postInstall = ''
    mv $out/lib/libquery_engine${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/libquery_engine.node
  '';

  # Tests are long to compile
  doCheck = false;

  meta = with lib; {
    description = "Collection of engines that power the core stack for Prisma";
    homepage = "https://www.prisma.io/";
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "prisma";
    maintainers = with maintainers; [ pimeys tomhoule aqrln ];
  };
}

### Troubleshooting
# Here's an example application using Prisma with Nix: https://github.com/pimeys/nix-prisma-example
# At example's `flake.nix` shellHook, notice the requirement of defining environment variables for prisma, it's values will show on `prisma --version`.
# Read the example's README: https://github.com/pimeys/nix-prisma-example/blob/main/README.md
# Prisma requires 2 packages, `prisma-engines` and `prisma`, to be at *exact* same versions.
# Certify at `package.json` that dependencies "@prisma/client" and "prisma" are equal, meaning no caret (`^`) in version.
# Configure NPM to use exact version: `npm config set save-exact=true`
# Delete `package-lock.json`, delete `node_modules` directory and run `npm install`.
# Run prisma client from `node_modules/.bin/prisma`.
# Run `./node_modules/.bin/prisma --version` and check if both prisma packages versions are equal, current platform is `linux-nixos`, and other keys equal to the prisma environment variables you defined for prisma.
# Test prisma with `generate`, `db push`, etc. It should work. If not, open an issue.
