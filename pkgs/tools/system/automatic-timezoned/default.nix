{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "automatic-timezoned";
  version = "2.0.15";

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iYsZSWWgapKj5EwGdAsv4YR2sEqGEol3VsZsOPFHAtA=";
  };

  cargoHash = "sha256-ZlKG+KU1CjxSMA+hZ+kWrJ68kuJjDLJF8dAU/BHCBRw=";

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
