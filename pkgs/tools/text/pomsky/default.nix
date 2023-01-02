{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "pomsky";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "rulex-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bb28f80wxjpy23mp9zamkprl8xbnx99rmmn8nxcaapq360zv9yi";
  };

  cargoSha256 = "sha256-Io8Ar7eNgULBIzI0rlitMI+9hLLWzI8pFwmH38hVVYU=";

  meta = with lib; {
    description = "A portable, modern regular expression language";
    homepage = "https://pomsky-lang.org";
    changelog = "https://github.com/rulex-rs/pomsky/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
