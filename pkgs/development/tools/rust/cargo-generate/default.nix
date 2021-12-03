{ lib, stdenv, fetchFromGitHub, rustPlatform, Security, openssl, pkg-config, libiconv, curl }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-generate";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "ashleygwilliams";
    repo = "cargo-generate";
    rev = "v${version}";
    sha256 = "sha256-082rFxC/p68X8g58I7Q7Of70ymq7VsLhkQpcqVx0u/A=";
  };

  cargoSha256 = "sha256-1yTH5FvalzBD13FXh/X1jmZhVyWU3thrjNSsrHUfBNE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl  ]
    ++ lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  preCheck = ''
    export HOME=$(mktemp -d) USER=nixbld
    git config --global user.name Nixbld
    git config --global user.email nixbld@localhost.localnet
  '';

  # Exclude some tests that don't work in sandbox:
  # - favorites_default_to_git_if_not_defined: requires network access to github.com
  # - should_canonicalize: the test assumes that it will be called from the /Users/<project_dir>/ folder on darwin variant.
  checkFlags = [ "--skip favorites::favorites_default_to_git_if_not_defined" ]
      ++ lib.optionals stdenv.isDarwin [ "--skip git::should_canonicalize" ];

  meta = with lib; {
    description = "cargo, make me a project";
    homepage = "https://github.com/ashleygwilliams/cargo-generate";
    license = licenses.asl20;
    maintainers = [ maintainers.turbomack ];
  };
}
