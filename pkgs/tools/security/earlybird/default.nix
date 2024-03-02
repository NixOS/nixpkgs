{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "earlybird";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "americanexpress";
    repo = "earlybird";
    rev = "v${version}";
    hash = "sha256-guSm/ha4ICaOcoynvAwFeojE6ikaCykMcdfskD/ehTw=";
  };

  vendorHash = "sha256-39jXqCXAwg/C+9gEXiS1X58OD61nMNQifnhgVGEF6ck=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A sensitive data detection tool capable of scanning source code repositories for passwords, key files, and more";
    homepage = "https://github.com/americanexpress/earlybird";
    changelog = "https://github.com/americanexpress/earlybird/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
