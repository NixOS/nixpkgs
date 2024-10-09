{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "weaviate";
  version = "1.26.4";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate";
    rev = "v${version}";
    hash = "sha256-JnzQ+B5zxbKZQ/jzOsD7r58f+TaCivN4BTJyNImi9xE=";
  };

  vendorHash = "sha256-QwB97LNUFK8yuKK8JSy1uH2hu+8ZAlvc+9VlTIld83U=";

  subPackages = [ "cmd/weaviate-server" ];

  ldflags = [ "-w" "-extldflags" "-static" ];

  postInstall = ''
    ln -s $out/bin/weaviate-server $out/bin/weaviate
  '';

  meta = with lib; {
    description = "ML-first vector search engine";
    homepage = "https://github.com/semi-technologies/weaviate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dit7ya ];
  };
}
