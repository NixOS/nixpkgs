{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "weaviate";
  version = "1.25.5";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate";
    rev = "v${version}";
    hash = "sha256-tkTsZ9iDZdQARhkEUyRYm77ebUCwNWgDdDEjLj7LOgY=";
  };

  vendorHash = "sha256-40O6MF1Tk9ZhGVLcKGzoUTaUFjKuXdpIHbB1GuRgyL8=";

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
