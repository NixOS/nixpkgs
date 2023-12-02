{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, perl
, pkg-config
, SystemConfiguration
, Security
, CoreFoundation
, curl
, libiconv
, openssl
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-crev";
  version = "0.25.5";

  src = fetchFromGitHub {
    owner = "crev-dev";
    repo = "cargo-crev";
    rev = "v${version}";
    sha256 = "sha256-Pp+D2s7kj+atMc5En+7v3KIYNCAscmDO1LK6x+ctyvY=";
  };

  # The package depends on "index-guix", which is (in the Cargo.toml) a path
  # dependency, but the repository does not ship that dependency.
  #
  # Upstream Issue: https://github.com/crev-dev/cargo-crev/issues/694
  buildNoDefaultFeatures = true;
  buildFeatures = [ "debcargo" ];

  cargoHash = "sha256-115OZCnshGOUKVaBTbFAiMpYdsNC/96gV+rOgiuwDYc=";

  preCheck = ''
    export HOME=$(mktemp -d)
    git config --global user.name "Nixpkgs Test"
    git config --global user.email "nobody@example.com"
  '';

  nativeBuildInputs = [ perl pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ SystemConfiguration Security CoreFoundation libiconv curl ];

  nativeCheckInputs = [ git ];

  meta = with lib; {
    description = "A cryptographically verifiable code review system for the cargo (Rust) package manager";
    homepage = "https://github.com/crev-dev/cargo-crev";
    license = with licenses; [ asl20 mit mpl20 ];
    maintainers = with maintainers; [ b4dm4n matthiasbeyer ];
  };
}
