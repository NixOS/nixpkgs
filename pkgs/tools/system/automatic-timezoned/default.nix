{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "automatic-timezoned";
  version = "1.0.41";

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KT1mVP2pMn6M8BPBdBgK94iLuAuoUwGo24L5IT5fVAQ=";
  };

  cargoSha256 = "sha256-hfhSbpNVJm6OE/wL3aPNRV+kJGIZnpoTh8e/trRG21c=";

  meta = with lib; {
    description = "Automatically update system timezone based on location";
    homepage = "https://github.com/maxbrunet/automatic-timezoned";
    license = licenses.gpl3;
    maintainers = with maintainers; [ maxbrunet ];
    platforms = platforms.linux;
  };
}
