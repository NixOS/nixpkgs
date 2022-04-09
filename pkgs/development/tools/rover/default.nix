{ lib
, callPackage
, fetchFromGitHub
, perl
, rustPlatform
, librusty_v8 ? callPackage ./librusty_v8.nix { }
}:

rustPlatform.buildRustPackage rec {
  pname = "rover";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "apollographql";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9o2bGa9vxN7EprKgsy9TI7AFmwjo1OT1pDyiLierTq0=";
  };

  cargoSha256 = "sha256-4oNuyZ1xNK2jP9QFEcthCjEQRyvFykd5N0j5KCXrzVY=";

  # The v8 package will try to download a `librusty_v8.a` release at build time
  # to our read-only filesystem. To avoid this we pre-download the file and
  # export it via RUSTY_V8_ARCHIVE
  RUSTY_V8_ARCHIVE = librusty_v8;

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
