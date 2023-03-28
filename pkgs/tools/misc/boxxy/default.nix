{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "boxxy";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "queer";
    repo = "boxxy";
    rev = "v${version}";
    hash = "sha256-05bGVtjbyd9e/Ega/Lv1Yy4gVDlJfygxD1g8bu5FuWY=";
  };

  cargoHash = "sha256-uzgMqfQCUzOOYCirLWsH2xm02T0UZXcMKCMmM45AkBg=";

  meta = with lib; {
    description = "Puts bad Linux applications in a box with only their files";
    homepage = "https://github.com/queer/boxxy";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya figsoda ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
