{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "extrude";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7gCEBhnNU5CqC5n0KP4Dd/fmddPRwNqyMFXTrRrJjfU=";
  };

  vendorSha256 = "sha256-auhRXKt5dcQ+gr3a9Wfen8/BISP17HVsIRP16sBmiZM=";

  meta = with lib; {
    description = "Tool to analyse binaries for missing security features";
    homepage = "https://github.com/liamg/extrude";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
