{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "richgo";
  version = "0.3.12";

  src = fetchFromGitHub {
    owner = "kyoh86";
    repo = "richgo";
    rev = "v${version}";
    sha256 = "sha256-pOB1exuwGwSxStodKhLLwh1xBvLjopUn0k+sEARdA9g=";
  };

  vendorHash = "sha256-jIzBN5T5+eTFCYOdS5hj3yTGOfU8NTrFmnIu+dDjVeU=";

  meta = with lib; {
    description = "Enrich `go test` outputs with text decorations";
    mainProgram = "richgo";
    homepage = "https://github.com/kyoh86/richgo";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
