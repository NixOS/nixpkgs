{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "automatic-timezoned";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-znoQPpnBU3cLxNmnIKvqj/fIuZDGCdmICx2UL1tqAnc=";
  };

  cargoHash = "sha256-1G81O+WKGVnRLGS6/6iiqsMiY5AaFrzEa9JD1MBDSGY=";

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
