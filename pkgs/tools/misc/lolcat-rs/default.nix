{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "lolcat-rs";
  version = "1.5.0";

  src = fetchCrate {
    crateName = "lolcat";
    inherit version;
    hash = "sha256-RVYmBfF9BlS9WSBcnptlgZ2nF7b7NC+58cZMHVX7SxQ=";
  };

  cargoHash = "sha256-hfcQsB4c+0/BmAV7Q0NUcGjedc35teDGRv5fDyyvp2c=";

  meta = with lib; {
    description = "A rainbow version of cat, implemented in Rust for speed";
    homepage = "https://github.com/ur0/lolcat";
    license = licenses.mit;
    maintainers = with maintainers; [ mirrorwitch ];
  };
}
