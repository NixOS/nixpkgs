{
  lib,
  fetchFromGitHub,
  perl,
  rustPlatform,
  darwin,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "rover";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "apollographql";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-c1Tnb9ACyV6RZmYnLL+KnybGgy8kwGi0JyWYcoH1J6M=";
  };

  cargoSha256 = "sha256-wTvQ4QBysppMgwv9pjQckVjMoBzLiDReOt6sJImqKFY=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.SystemConfiguration
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

  passthru.updateScript = ./update.sh;

  # Some tests try to write configuration data to a location in the user's home
  # directory. Since this would be /homeless-shelter during the build, point at
  # a writeable location instead.
  preCheck = ''
    export APOLLO_CONFIG_HOME="$PWD"
  '';

  meta = with lib; {
    description = "A CLI for interacting with ApolloGraphQL's developer tooling, including managing self-hosted and GraphOS graphs.";
    mainProgram = "rover";
    homepage = "https://www.apollographql.com/docs/rover";
    license = licenses.mit;
    maintainers = [
      maintainers.ivanbrennan
      maintainers.aaronarinder
    ];
  };
}
