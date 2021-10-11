{ lib
, buildGoModule
, curl
, fetchFromGitHub
, pkg-config
}:

buildGoModule rec {
  pname = "cameradar";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "Ullaakut";
    repo = pname;
    rev = "v${version}";
    sha256 = "03nm03cqhq04ixw4rssfkgrin918pa0v7ai26v4h99gz7j8hs7ll";
  };

  vendorSha256 = "099np130dn51nb4lcyrrm46fihfipxrw0vpqs2jh5g4c6pnbk200";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    curl
  ];

  subPackages = [
    "cmd/cameradar"
  ];
  # At least one test is outdated
  #doCheck = false;

  meta = with lib; {
    description = "RTSP stream access tool";
    homepage = "https://github.com/Ullaakut/cameradar";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
