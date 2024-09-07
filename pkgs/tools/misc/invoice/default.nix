{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "invoice";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "invoice";
    rev = "v${version}";
    hash = "sha256-WtQ4nF31uIoplY18GZNs41ZOCxmbIu71YpEGk8aTGww=";
  };

  vendorHash = "sha256-8VhBflnpsJ5h8S6meDFZKCcS2nz5u4kPE9W710gJG4U=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command line invoice generator";
    homepage = "https://github.com/maaslalani/invoice";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "invoice";
  };
}
