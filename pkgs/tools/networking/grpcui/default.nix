{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "grpcui";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b6rc294v8jagk79hcjbaldfi7y7idx8bknsbdi3djym5rspdg6s";
  };

  vendorSha256 = "0wih9xvpgqqd82v1pxy5rslrsd6wsl0ys1bi1mf373dnfq5vh5a9";

  subPackages = [ "cmd/grpcui" ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "An interactive web UI for gRPC, along the lines of postman";
    homepage = "https://github.com/fullstorydev/grpcui";
    license = licenses.mit;
    maintainers = with maintainers; [ pradyuman ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
