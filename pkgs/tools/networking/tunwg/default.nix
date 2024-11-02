{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tunwg";
  version = "24.09.18+760ee81";

  src = fetchFromGitHub {
    owner = "ntnj";
    repo = "tunwg";
    rev = "v${version}";
    hash = "sha256-+vgl7saHp1Co35nkxQ+IhqYr6GdGd0JIFEFrezQd5Yo=";
  };

  vendorHash = "sha256-5BJFAnsmx6lbGQTx/6dIdcsETsllCr6C3wPbB2Gvj5Y=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Secure private tunnel to your local servers";
    homepage = "https://github.com/ntnj/tunwg";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "tunwg";
  };
}
