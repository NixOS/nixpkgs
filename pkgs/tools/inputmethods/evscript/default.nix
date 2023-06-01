{ lib, rustPlatform, fetchFromGitea }:

rustPlatform.buildRustPackage rec {
  pname = "evscript";
  version = "unstable-2022-11-20";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "valpackett";
    repo = pname;
    rev = "ba997c9723a91717c683f08e9957d0ecea3da6cd";
    sha256 = "sha256-wuTPcBUuPK1D4VO8BXexx9AdiPM+X0TkJ3G7b7ofER8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "evdev-0.10.1" = "sha256-iIzKhlA+7qg+nNwP82OIpoXVUEYU31iSEt1KJA3EewQ=";
    };
  };

  meta = with lib; {
    homepage = "https://codeberg.org/valpackett/evscript";
    description = "A tiny sandboxed Dyon scripting environment for evdev input devices";
    license = licenses.unlicense;
    maintainers = with maintainers; [ milesbreslin ];
    platforms = platforms.linux;
  };
}
