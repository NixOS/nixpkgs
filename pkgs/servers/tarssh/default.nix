{ fetchFromGitHub, rustPlatform, stdenv }:

with rustPlatform;

buildRustPackage rec {
  pname = "tarssh";
  version = "0.4.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Freaky";
    repo = pname;
    sha256 = "0fm0rwknhm39nhd6g0pnxby34i5gpmi5ri795d9ylsw0pqwz6kd0";
  };

  cargoSha256 = "108xdpgfgfd4z455snif0mzbla0rv8gjqxci5qgwjzfyshwkprgv";

  meta = with stdenv.lib; {
    description = "A simple SSH tarpit inspired by endlessh";
    homepage = "https://github.com/Freaky/tarssh";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ sohalt ];
    platforms = platforms.unix ;
  };
}
