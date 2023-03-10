{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xc";
  version = "0.0.175";

  src = fetchFromGitHub {
    owner = "joerdav";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Uc9MTxl32xQ7u6N0mocDAoD9tgv/YOPCzhonsavX9Vo=";
  };

  vendorHash = "sha256-cySflcTuAzbFZbtXmzZ98nfY8HUq1UedONTtKP4EICs=";

  meta = with lib; {
    homepage = "https://xcfile.dev/";
    description = "Markdown defined task runner";
    license = licenses.mit;
    maintainers = with maintainers; [ joerdav ];
  };
}
