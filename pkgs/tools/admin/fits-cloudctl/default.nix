{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "sha256-oqG9E1sSmpV2S7ywLCBRFs9d3Tbv5uxrbRh5DwpktkA=";
  };

  vendorSha256 = "sha256-+2KgRGQIkTHbVzFIv0FVLWuDegk7pZ/H+u07A1PjM/4=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
