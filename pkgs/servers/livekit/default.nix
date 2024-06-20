{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "livekit";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-O+nmPbh5msecYrMcXGzh+JmNXKjHt+M66yMYZ7LRDjc=";
  };

  vendorSha256 = "sha256-V2svyh/QegO6/03cq8iWBxNMYtt+imFUrTwgLtB19uw=";

  subPackages = [ "cmd/server" ];

  postInstall = ''
    mv "$out/bin/server" "$out/bin/livekit"
  '';

  meta = with lib; {
    description = "Scalable, high-performance WebRTC SFU";
    homepage = "https://github.com/livekit/livekit";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
