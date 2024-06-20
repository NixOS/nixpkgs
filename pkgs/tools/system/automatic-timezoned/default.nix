{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "automatic-timezoned";
  version = "2.0.16";

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ew2UiWq/K93HfKqaQoDHPrkKgHkgzzzdQwJTXmSYTeE=";
  };

  cargoHash = "sha256-HsLDpfdL5/rQU8usKiWRnbZ5s6XxchbHpp+9SFhoDi4=";

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
