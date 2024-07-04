{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cayley";
  version = "0.7.7";
  rev = "dcf764fef381f19ee49fad186b4e00024709f148";

  src = fetchFromGitHub {
    owner = "cayleygraph";
    repo = "cayley";
    rev = "v${version}";
    sha256 = "sha256-jIX0v6ujiQvEAb/mKkrpNgsY0YLkJYHy2sUfQnooE48=";
  };

  vendorHash = "sha256-SSjHGJoW3I7r8emh3IwmiZQIVzdilAsA2ULdAqld2fA=";

  subPackages = [ "cmd/cayley" ];

  ldflags = let basename = "github.com/cayleygraph/cayley/version"; in [
    "-s"
    "-w"
    "-X ${basename}.Version=${src.rev}"
    "-X ${basename}.GitHash=${rev}"
  ];

  meta = with lib; {
    description = "Graph database designed for ease of use and storing complex data";
    longDescription = ''
      Cayley is an open-source database for Linked Data. It is inspired by the
      graph database behind Google's Knowledge Graph (formerly Freebase).
    '';
    homepage = "https://cayley.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ sigma ];
    mainProgram = "cayley";
  };
}
