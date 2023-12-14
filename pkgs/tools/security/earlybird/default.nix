{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "earlybird";
  version = "3.16.0";

  src = fetchFromGitHub {
    owner = "americanexpress";
    repo = "earlybird";
    rev = "v${version}";
    hash = "sha256-qSW8O13UW5L2eVsqIuqOguhCyZBPqevZ9fJ7qkraa7M=";
  };

  patches = [
    ./fix-go.mod-dependency.patch
  ];

  vendorHash = "sha256-ktsQvWc0CTnqOer+9cc0BddrQp0F3Xk7YJP3jxfuw1w=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A sensitive data detection tool capable of scanning source code repositories for passwords, key files, and more";
    homepage = "https://github.com/americanexpress/earlybird";
    changelog = "https://github.com/americanexpress/earlybird/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
