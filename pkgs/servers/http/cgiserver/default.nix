{ lib, buildGoModule, fetchzip, zstd }:

buildGoModule rec {
  pname = "cgiserver";
  version = "1.0.0";

  src = fetchzip {
    url = "https://src.anomalous.eu/cgiserver/snapshot/cgiserver-${version}.tar.zst";
    nativeBuildInputs = [ zstd ];
    hash = "sha256-uIrOZbHzxAdUJF12MBOzRUA6mSPvOKJ/K9ZwwLVId5E=";
  };

  vendorHash = "sha256-mygMtVbNWwtIkxTGxMnuAMUU0mp49NZ50B9d436nWgI=";

  meta = with lib; {
    homepage = "https://src.anomalous.eu/cgiserver/about/";
    description = "Lightweight web server for sandboxing CGI applications";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.osl3;
  };
}
