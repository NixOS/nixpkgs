{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "boxxy";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "queer";
    repo = "boxxy";
    rev = "v${version}";
    hash = "sha256-842vddqxxWh64uYrSk0bugx5hhhCnliSO1zoTmm5iVk=";
  };

  cargoHash = "sha256-BwdGed5PvlPxtx0FcT4G7RG0M8fAUOuX7c+uR/m0Sz4=";

  meta = with lib; {
    description = "Puts bad Linux applications in a box with only their files";
    homepage = "https://github.com/queer/boxxy";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya figsoda ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
