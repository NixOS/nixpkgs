{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vale";
  version = "2.14.0";

  subPackages = [ "cmd/vale" ];
  outputs = [ "out" "data" ];

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "vale";
    rev = "v${version}";
    sha256 = "sha256-4kFd2ULap9kcMu81Lu0SxER7xDAnVVyi9yAVsS1yhnw=";
  };

  vendorSha256 = "sha256-MGNv1mEIOvhcpL40MuQob5Uu4qqIGhJxPZTi8BvqQ0s=";

  postInstall = ''
    mkdir -p $data/share/vale
    cp -r styles $data/share/vale
  '';

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://docs.errata.ai/vale/about";
    description = "A syntax-aware linter for prose built with speed and extensibility in mind";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
