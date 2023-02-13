{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "boxxy";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "queer";
    repo = "boxxy";
    rev = "v${version}";
    hash = "sha256-mvSarA0rZuOQvgf2NJXWIWoeZtvb+D/GofAHPKQDH6U=";
  };

  cargoHash = "sha256-Psc9qErqi3aangNowXxhkEXphFCR7pp+DKTKtk6tMo0=";

  meta = with lib; {
    description = "Puts bad Linux applications in a box with only their files";
    homepage = "https://github.com/queer/boxxy";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    platforms = platforms.linux;
  };
}
