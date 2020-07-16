{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "0a00sw6r8z6pyqqa6f5c7czxjnjdx3kz1bacy790nsngvz17l30h";
  };

  cargoSha256 = "0x92yh9pl30h4k53269dgnryb6z8nfl2mfx3wpcp3ph5na2knwpj";

  meta = with lib; {
    description =
      "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ xrelkd ];
  };
}
