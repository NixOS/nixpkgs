{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "cargo-license";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "onur";
    repo = "cargo-license";
    rev = "v${version}";
    sha256 = "0xxgl9d695ncrxz29125wag285dwxpwc3fym0ixgj5fqbnkbx75g";
  };

  cargoPatches = [ ./add-Cargo.lock.patch ];

  cargoSha256 = "0jc84v8fxzzyfkcnfr9vrdblw5vdk54nzpch5lcarzfsarncqxw7";

  meta = with lib; {
    description = "Cargo subcommand to see license of dependencies";
    homepage = "https://github.com/onur/cargo-license";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ basvandijk ];
    platforms = platforms.all;
  };
}
