{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gofumpt";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8wTS8CAAL65VSN+sM275W5eWDivp9qOMbAQmFTCKUI0=";
  };

  vendorHash = "sha256-SFKS9lYPiZNu1w20Z7UEp2d0xjc5kuqVEADZaUF1Gyc=";

  checkFlags = [
    # Requires network access (Error: module lookup disabled by GOPROXY=off).
    "-skip=^TestScript/diagnose$"
  ];

  meta = with lib; {
    description = "A stricter gofmt";
    homepage = "https://github.com/mvdan/gofumpt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs ];
    mainProgram = "gofumpt";
  };
}
