{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "neo-cowsay";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "Code-Hex";
    repo = "Neo-cowsay";
    rev = "v${version}";
    sha256 = "sha256-n01C6Z9nV2DDbSqgbOIZTqZAWXo6h4/NJdyFiOCh79A=";
  };

  vendorSha256 = "sha256-4qMsyNFD2MclsseE+IAaNm5r0wHWdcwLLPsZ0JJ3qpw=";

  doCheck = false;

  subPackages = [ "cmd/cowsay" "cmd/cowthink" ];

  meta = with lib; {
    description = "Cowsay reborn, written in Go";
    homepage = "https://github.com/Code-Hex/Neo-cowsay";
    license = with licenses; [artistic1 /* or */ gpl3];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
