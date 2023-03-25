{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "automatic-timezoned";
  version = "1.0.75";

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-soEVET3aVK77UJjhXq/cwK9QWAJWQu5TEjyHEKfqKeY=";
  };

  cargoHash = "sha256-xux+8hix2FzZqxOmos1g0SAcVVajJUCO9qGl0LNtOlk=";

  meta = with lib; {
    description = "Automatically update system timezone based on location";
    homepage = "https://github.com/maxbrunet/automatic-timezoned";
    changelog = "https://github.com/maxbrunet/automatic-timezoned/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3;
    maintainers = with maintainers; [ maxbrunet ];
    platforms = platforms.linux;
  };
}
