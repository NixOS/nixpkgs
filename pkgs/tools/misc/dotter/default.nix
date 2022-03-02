{ lib, fetchFromGitHub, rustPlatform, which }:

rustPlatform.buildRustPackage rec {
  pname = "dotter";
  version = "0.12.9";

  src = fetchFromGitHub {
    owner = "SuperCuber";
    repo = "dotter";
    rev = version;
    sha256 = "0rxinrm110i5cbkl7c7vgk7dl0x79cg6g23bdjixsg7h0572c2gi";
  };

  cargoSha256 = "0fr2dvzbpwqvf98wwrxv76nwbrv4m9ppx7br4x78gm8dhf2nj4zx";

  checkInputs = [ which ];

  meta = with lib; {
    description = "A dotfile manager and templater written in rust 🦀";
    homepage = "https://github.com/SuperCuber/dotter";
    license = licenses.unlicense;
    maintainers = with maintainers; [ linsui ];
    mainProgram = "dotter";
  };
}
