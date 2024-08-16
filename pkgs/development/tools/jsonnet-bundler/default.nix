{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "jsonnet-bundler";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "jsonnet-bundler";
    repo = "jsonnet-bundler";
    rev = "v${version}";
    sha256 = "sha256-vjb5wEiJw48s7FUarpA94ZauFC7iEgRDAkRTwRIZ8pA=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  meta = with lib; {
    description = "Jsonnet package manager";
    homepage = "https://github.com/jsonnet-bundler/jsonnet-bundler";
    license = licenses.asl20;
    maintainers = with maintainers; [ preisschild ];
    mainProgram = "jb";
  };
}
