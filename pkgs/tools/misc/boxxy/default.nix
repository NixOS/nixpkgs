{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, oniguruma
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "boxxy";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "queer";
    repo = "boxxy";
    rev = "v${version}";
    hash = "sha256-hA+xgvixq9h8HdUVM/8WvYhl+aADiqkMLp0JPLD0YUE=";
  };

  cargoHash = "sha256-LLDlnCO2POMcchXwbUuEYfM8tFlOLGzv6ErgXsobfsU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = with lib; {
    description = "Puts bad Linux applications in a box with only their files";
    homepage = "https://github.com/queer/boxxy";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya figsoda ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
