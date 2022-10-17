{ lib
, callPackage
, fetchFromGitHub
, perl
, rustPlatform
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rover";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "apollographql";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gcSRW4Tbbfn0A2P8ymHwu4P2Ox4INYUw5vEMUcAA9Dc=";
  };

  cargoSha256 = "sha256-YVXpIsuchbv0mvKbUfhsuPzkmxyAWG9zP7h4iyL1ih0=";

  patches = [
    ./logic.patch
  ];

  nativeBuildInputs = [
    perl
  ];

  buildInputs = [] ++ lib.lists.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.CoreFoundation
  ];

  # The rover-client's build script (crates/rover-client/build.rs) will try to
  # download the API's graphql schema at build time to our read-only filesystem.
  # To avoid this we pre-download it to a location the build script checks.
  preBuild = ''
    mkdir crates/rover-client/.schema
    cp ${./schema}/hash.id        crates/rover-client/.schema/
    cp ${./schema}/schema.graphql crates/rover-client/.schema/
  '';

  passthru.updateScript = ./update.sh;

  # Some tests try to write configuration data to a location in the user's home
  # directory. Since this would be /homeless-shelter during the build, point at
  # a writeable location instead.
  preCheck = ''
    export APOLLO_CONFIG_HOME="$PWD"
  '';

  meta = with lib; {
    description = "A CLI for managing and maintaining graphs with Apollo Studio";
    homepage = "https://www.apollographql.com/docs/rover";
    license = licenses.mit;
    maintainers = [ maintainers.ivanbrennan ];
    platforms = ["x86_64-linux"] ++ lib.platforms.darwin;
  };
}
