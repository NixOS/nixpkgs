{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lokalise2-cli";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "lokalise";
    repo = "lokalise-cli-2-go";
    rev = "v${version}";
    sha256 = "sha256-woRFrw51F9f+dGTkEPuN9ushGfEDwR59uqZIv78PLHE=";
  };

  vendorHash = "sha256-SDI36+35yFy7Fp+VrnQMyIDUY1kM2tylwdS3I9E2vyk=";

  doCheck = false;

  postInstall = ''
    mv $out/bin/lokalise-cli-2-go $out/bin/lokalise2
  '';

  meta = with lib; {
    description = "Translation platform for developers. Upload language files, translate, integrate via API";
    homepage = "https://lokalise.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ timstott ];
    mainProgram = "lokalise2";
  };
}
