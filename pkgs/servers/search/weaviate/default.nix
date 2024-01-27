{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "weaviate";
  version = "1.23.1";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate";
    rev = "v${version}";
    hash = "sha256-sQp0RarW+SRxhDmXm1fSI1xEPKPMQ8coJiyJK5d2NlA=";
  };

  vendorHash = "sha256-UEdGoXKq7ewNszahgcomjjuO2uzRZpiwkvvnXyFc9Og=";

  subPackages = [ "cmd/weaviate-server" ];

  ldflags = [ "-w" "-extldflags" "-static" ];

  postInstall = ''
    ln -s $out/bin/weaviate-server $out/bin/weaviate
  '';

  meta = with lib; {
    description = "The ML-first vector search engine";
    homepage = "https://github.com/semi-technologies/weaviate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dit7ya ];
  };
}
