{ lib
, rustPlatform
, fetchFromGitHub
, perl
, openssl
, pkg-config
, Security
, stdenv
}:

let
  # The build fetches this dynamically from https://graphql.api.apollographql.com/api/schema
  apolloSchema = builtins.readFile ./schema.graphql;
  # The build fetches this from the headers of https://graphql.api.apollographql.com/api/schema
  etagId = "a7252784c3d195f1ffec315fb8b1481cfba06c7943fe9020ab8df2aafd4d479e";
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
  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  # Put schema in place that would otherwise be dynamically fetched during the build
  preBuild = ''
    mkdir -p crates/rover-client/.schema
    cp $apolloSchemaPath crates/rover-client/.schema/schema.graphql
    echo ${etagId} > crates/rover-client/.schema/etag.id
  '';
  inherit apolloSchema;
  passAsFile = [ "apolloSchema" ];
  patches = [ ./patches/disable-dynamic-schema-fetching.patch ];

  # Tests currently contain some impurities fetched over the network and I'm too lazy to fix that
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
  };
}
