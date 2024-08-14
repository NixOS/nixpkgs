{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "automatic-timezoned";
  version = "2.0.27";

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Qp5f8c7ET74djXzZr2sZZy+4GUQwUPxSTtgQhoRJURg=";
  };

  cargoHash = "sha256-ZvFKOlNagjH//WTPV/QeCOPvjLcimJ0v6YS0nXujhQA=";

  meta = with lib; {
    description = "Automatically update system timezone based on location";
    homepage = "https://github.com/maxbrunet/automatic-timezoned";
    changelog = "https://github.com/maxbrunet/automatic-timezoned/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3;
    maintainers = with maintainers; [ maxbrunet ];
    platforms = platforms.linux;
    mainProgram = "automatic-timezoned";
  };
}
