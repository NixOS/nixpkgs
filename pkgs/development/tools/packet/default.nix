{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "packet";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "ebsarr";
    repo = "packet";
    rev = "v${version}";
    hash = "sha256-jm9u+LQE48aqO6CLdLZAw38woH1phYnEYpEsRbNwyKI=";
  };

  vendorHash = "sha256-K+gLn6EM6tvgpBwnrlDoBW76iQE8CsIuUP/eoNm5PCs=";

  preBuild = ''
    cp ${./go.mod} go.mod
    cp ${./go.sum} go.sum
  '';

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "a CLI tool to manage packet.net services";
    mainProgram = "packet";
    homepage = "https://github.com/ebsarr/packet";
    license = licenses.mit;
    maintainers = with maintainers; [ grahamc ];
    platforms = platforms.unix;
  };
}
