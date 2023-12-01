{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "jotdown";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "hellux";
    repo = "jotdown";
    rev = version;
    hash = "sha256-XouI3PHKPtX+3GkhMvdRfwJkCoofMgCY/NXB0tnLyUc=";
  };

  cargoHash = "sha256-PvKXVP90GOAgz4Sc37B4hli7rbNHVZbksVAo+uy2yEU=";

  meta = with lib; {
    description = "A minimal Djot CLI";
    homepage = "https://github.com/hellux/jotdown";
    changelog = "https://github.com/hellux/jotdown/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
