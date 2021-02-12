{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-kcov";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "kennytm";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hqplgj3i8js42v2kj44khk543a93sk3n6wlfpv3c84pdqlm29br";
  };

  cargoSha256 = "0nlm13vscyr0is451j581kzra4isl3x1zvp2if2hp2pjcyqvf77c";
  doCheck = false;

  meta = with lib; {
    description = "Cargo subcommand to run kcov to get coverage report on Linux";
    homepage = "https://github.com/kennytm/cargo-kcov";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ saschagrunert ];
  };
}
