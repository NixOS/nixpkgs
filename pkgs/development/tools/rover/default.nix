{ lib
, callPackage
, fetchFromGitHub
, perl
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "rover";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "apollographql";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wBHMND/xpm9o7pkWMUj9lEtEkzy3mX+E4Dt7qDn6auY=";
  };

  cargoSha256 = "sha256-n0R2MdAYGsOsYt4x1N1KdGvBZYTALyhSzCGW29bnFU4=";

  nativeBuildInputs = [
    perl
  ];

  # The rover-client's build script (crates/rover-client/build.rs) will try to
  # download the API's graphql schema at build time to our read-only filesystem.
  # To avoid this we pre-download it to a location the build script checks.
  preBuild = ''
    mkdir crates/rover-client/.schema
    cp ${./schema}/etag.id        crates/rover-client/.schema/
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
    platforms = ["x86_64-linux"];
  };
}
