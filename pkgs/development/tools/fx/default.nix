{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fx";
  version = "30.1.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = pname;
    rev = version;
    hash = "sha256-SqD3NPaeJB/bxb47PO39mwJGnSg2WBQ3RyA6PRn7z10=";
  };

  vendorHash = "sha256-6wVcdzTYnB0Bd/YLPcbryKxCXu5genzQQ96znbn2ahw=";

  meta = with lib; {
    description = "Terminal JSON viewer";
    homepage = "https://github.com/antonmedv/fx";
    changelog = "https://github.com/antonmedv/fx/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
