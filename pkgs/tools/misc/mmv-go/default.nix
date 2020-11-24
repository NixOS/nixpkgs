{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mmv-go";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = "mmv";
    rev = "v${version}";
    sha256 = "0kpf6abzhsikm7vyk5735p8sfjhsh7klla9qnmc43mgh0560f020";
  };

  vendorSha256 = "1nnfi5zad7nlp44mj0fdg09q8pm093di7rr7pknl9whqghv36dfi";

  buildFlagsArray = [ "-ldflags=-s -w -X main.revision=${src.rev}" ];

  meta = with lib; {
    homepage = "https://github.com/itchyny/mmv";
    description = "Rename multiple files using your $EDITOR";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
