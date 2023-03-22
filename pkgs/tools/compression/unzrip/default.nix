{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, zstd
}:

rustPlatform.buildRustPackage rec {
  pname = "unzrip";
  version = "unstable-2023-03-13";

  src = fetchFromGitHub {
    owner = "quininer";
    repo = "unzrip";
    rev = "bd2dffd43c3235857500190571602f3ce58c5f70";
    hash = "sha256-Ih47xF4JYQf10RuTnfJJGUAJwyxDxCAdTTCdwGf4i/U=";
  };

  cargoHash = "sha256-11UESSKvTcr6Wa0cASRSQ55kBbRL5AelI6thv3oi0sI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  meta = with lib; {
    description = "Unzip implementation, support for parallel decompression, automatic detection encoding";
    homepage = "https://github.com/quininer/unzrip";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
