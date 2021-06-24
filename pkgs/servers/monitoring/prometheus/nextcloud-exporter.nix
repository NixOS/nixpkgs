{ lib, fetchFromGitHub, buildGoModule, nixosTests, fetchpatch }:

buildGoModule rec {
  pname = "prometheus-nextcloud-exporter";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "xperimental";
    repo = "nextcloud-exporter";
    rev = "v${version}";
    sha256 = "0kq0ka2gjlibl7vhk3s4z15ja5ai7cmwl144gj4dyhylp2xzr72a";
  };

  vendorSha256 = "0qs3p4jl8p0323bklrrhxzql7652pm6a1hj9ch9xyfhkwsx87l4d";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nextcloud; };

  meta = with lib; {
    description = "Prometheus exporter for Nextcloud servers";
    homepage = "https://github.com/xperimental/nextcloud-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    platforms = platforms.unix;
  };
}
