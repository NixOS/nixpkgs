{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libelf
, zlib
, ncurses
, clang
, rustfmt
}:
rustPlatform.buildRustPackage rec {
  pname = "below";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IUBC7E2Gx4X4PAh74dSF4ggTxU1IZ7E/X4gMZN4lJt4=";
  };

  cargoPatches = [ ./Cargo.lock.patch ];

  cargoSha256 = "sha256-rwQRL9Cp9PPU4KywdC1czn08Vjbs1CzZe/e9gXDmfDk=";

  nativeBuildInputs = [ pkg-config clang rustfmt ];
  buildInputs = [ libelf zlib ncurses ];

  hardeningDisable = [ "stackprotector" ];

  doCheck = false; # 4 tests fail out of 9, most likely due to filesystem expectations

  meta = with lib; {
    description = "A time traveling resource monitor for modern Linux systems";
    homepage = "https://github.com/facebookincubator/below";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
