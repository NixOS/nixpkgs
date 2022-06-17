{ lib, buildGoModule, fetchzip, zstd }:

buildGoModule rec {
  pname = "cgiserver";
  version = "1.0.0";

  src = fetchzip {
    url = "https://src.anomalous.eu/cgiserver/snapshot/cgiserver-${version}.tar.zst";
    nativeBuildInputs = [ zstd ];
    sha256 = "14bp92sw0w6n5dzs4f7g4fcklh25nc9k0xjx4ia0gi7kn5jwx2mq";
  };

  vendorSha256 = "00jslxzf6p8zs1wxdx3qdb919i80xv4w9ihljd40nnydasshqa4v";

  meta = with lib; {
    homepage = "https://src.anomalous.eu/cgiserver/about/";
    description = "Lightweight web server for sandboxing CGI applications";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.osl3;
  };
}
