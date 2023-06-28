{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "automatic-timezoned";
  version = "1.0.102";

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4iHQ6mYG6DZa5RYPHW791J9kFqMDM9W+T3ufOg43u5g=";
  };

  cargoHash = "sha256-i98kWlkaijWNVycbkqrjo4GrQPz8wmZTO3vQaqukCuI=";

  meta = with lib; {
    description = "Automatically update system timezone based on location";
    homepage = "https://github.com/maxbrunet/automatic-timezoned";
    changelog = "https://github.com/maxbrunet/automatic-timezoned/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3;
    maintainers = with maintainers; [ maxbrunet ];
    platforms = platforms.linux;
  };
}
