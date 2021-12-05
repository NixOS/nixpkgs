{ lib, rustPlatform, fetchCrate, pkg-config, openssl, stdenv, curl, Security
, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.10.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-jg8KuIu1SaIRlEI9yvpLCESZfAyNgSThJ6pe7+IM6j0=";
  };

  cargoSha256 = "sha256-jfZUtUVHEC8zK+FJHSOQxELWTG/Of2WSDoqdg/Sckws=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ curl Security SystemConfiguration ];

  meta = with lib; {
    description =
      "A cargo subcommand for displaying when Rust dependencies are out of date";
    homepage = "https://github.com/kbknapp/cargo-outdated";
    changelog =
      "https://github.com/kbknapp/cargo-outdated/blob/${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ sondr3 ivan ];
  };
}
