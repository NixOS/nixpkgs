{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5PuSIOXns0FVLgyIw1mk8hZ/tYhikMV860BHTDlji78=";
  };

  cargoSha256 = "sha256-UbbVjT5JQuVSCgbcelEVaAql4CUnCtO99zHp3Ei31Gs=";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "emplace";
  };
}
