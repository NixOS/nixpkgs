{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "grpcui";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ssKVgvMO6+7/FQFxbHVTipDFVXZZ/9Ww/kFTqxTgdLQ=";
  };

  vendorHash = "sha256-ui/zaHwZH5zdrcKFXwIrJ3TCLUeONsjSexIHoa6hRH8=";

  doCheck = false;

  subPackages = [ "cmd/grpcui" ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "An interactive web UI for gRPC, along the lines of postman";
    homepage = "https://github.com/fullstorydev/grpcui";
    license = licenses.mit;
    maintainers = with maintainers; [ pradyuman ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
