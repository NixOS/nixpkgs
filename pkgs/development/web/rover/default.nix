{ lib
, rustPlatform
, fetchFromGitHub
, perl
, openssl
, pkg-config
, darwin
, stdenv
}:

let
  # The build fetches this dynamically from https://graphql.api.apollographql.com/api/schema
  apolloSchema = builtins.readFile ./schema.graphql;
  # The build fetches this from the headers of https://graphql.api.apollographql.com/api/schema
  etagId = builtins.readFile ./etag.id;
in
rustPlatform.buildRustPackage rec {
  pname = "rover";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "apollographql";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vmm35b9d7xw160pn797z78vj8jaav0qb6dw7n4ld8ssj076dsrh";
  };

  nativeBuildInputs = [ perl pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  # Put schema in place that would otherwise be dynamically fetched during the build
  preBuildPhase = [
    ''
      mkdir -p crates/rover-client/.schema
      cat $apolloSchemaPath > crates/rover-client/.schema/schema.graphql
      echo ${etagId} > crates/rover-client/.schema/etag.id
    ''
  ];
  preBuildPhases = [ "preBuildPhase" ];
  inherit apolloSchema;
  passAsFile = [ "apolloSchema" ];
  patches = [ ./patches/disable-dynamic-schema-fetching.patch ];

  # Disable tests for now
  doCheck = false;

  # Turn off features that depend on v8 which tries to download a bunch of stuff
  cargoBuildFlags = [ "--no-default-features" ];
  cargoSha256 = "1vkb7p8ably6myix4yx782g8bfklwic9lhawhlk3m7cj440p9rqy";

  meta = with lib; {
    description = "The new CLI for Apollo GraphQL";
    longDescription = ''
      Rover is a CLI for managing and maintaining data graphs with Apollo Studio.
    '';
    homepage = "https://www.apollographql.com/docs/rover/";
    changelog = "https://github.com/apollographql/rover/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ farlion edude03 ];
    platforms = platforms.all;
  };
}
