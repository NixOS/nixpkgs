{ lib
, callPackage
, fetchFromGitHub
, perl
, rustPlatform
, darwin
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "rover";
<<<<<<< HEAD
  version = "0.14.0";
=======
  version = "0.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "apollographql";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-fVgo5Ds/VK0kBpF+F2FdMvBnQj2IB+B5ToOK8ONdq6c=";
  };

  cargoSha256 = "sha256-fNqnpLNENLJEhbqxLFUqyjAf8tEPCLoGSRV91gOY9LI=";
=======
    sha256 = "sha256-Ei6EeM0+b3EsMoRo38nHO79onT9Oq/cfbiCZhyDYQrc=";
  };

  cargoSha256 = "sha256-+iDU8LPb7P4MNQ8MB5ldbWq4wWRcnbgOmSZ93Z//5O0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.CoreServices
  ];

  nativeBuildInputs = [
    perl
  ];

  # This test checks whether the plugins specified in the plugins json file are
  # valid by making a network call to the repo that houses their binaries; but, the
  # build env can't make network calls (impurity)
  cargoTestFlags = [
    "-- --skip=latest_plugins_are_valid_versions"
  ];

  # The rover-client's build script (xtask/src/commands/prep/schema.rs) will try to
  # download the API's graphql schema at build time to our read-only filesystem.
  # To avoid this we pre-download it to a location the build script checks.
  preBuild = ''
    cp ${./schema}/hash.id              crates/rover-client/.schema/
    cp ${./schema}/etag.id              crates/rover-client/.schema/
    cp ${./schema}/schema.graphql       crates/rover-client/.schema/
  '';

  passthru.updateScript = ./update.sh;

  # Some tests try to write configuration data to a location in the user's home
  # directory. Since this would be /homeless-shelter during the build, point at
  # a writeable location instead.
  preCheck = ''
    export APOLLO_CONFIG_HOME="$PWD"
  '';

  meta = with lib; {
    description = "A CLI for interacting with ApolloGraphQL's developer tooling, including managing self-hosted and GraphOS graphs.";
    homepage = "https://www.apollographql.com/docs/rover";
    license = licenses.mit;
    maintainers = [ maintainers.ivanbrennan maintainers.aaronarinder ];
  };
}
