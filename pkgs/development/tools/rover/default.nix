{
  lib,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  openssl,
  darwin,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "rover";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "apollographql";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uyeePAHBDCzXzwIWrKcc9LHClwSI7DMBYod/o4LfK+Y=";
  };

  cargoHash = "sha256-Rf4kRXYW+WAF1rM7o8PmXBLgp/YyA8y/TqbZL22VOqI=";

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  nativeBuildInputs = [
    pkg-config
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

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
    description = "CLI for interacting with ApolloGraphQL's developer tooling, including managing self-hosted and GraphOS graphs";
    mainProgram = "rover";
    homepage = "https://www.apollographql.com/docs/rover";
    license = licenses.mit;
    maintainers = [
      maintainers.ivanbrennan
      maintainers.aaronarinder
    ];
  };
}
