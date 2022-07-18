{ lib
, buildGoModule
, curl
, fetchFromGitHub
, pkg-config
}:

buildGoModule rec {
  pname = "cameradar";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "Ullaakut";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GOqmz/aiOLGMfs9rQBIEQSgBycPzhu8BohcAc2U+gBw=";
  };

  vendorSha256 = "sha256-AIi57DWMvAKl0PhuwHO/0cHoDKk5e0bJsqHYBka4NiU=";

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
