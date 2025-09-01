{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "cloudflare-exporter";
  version = "0.0.16";

  src = fetchFromGitHub {
    rev = version;
    owner = "lablabs";
    repo = pname;
    sha256 = "sha256-7cyHAN4VQWfWMdlFbZvHL38nIEeC1z/vpCDR5R2pOAw=";
  };

  vendorHash = "sha256-c1drgbzoA5AlbB0K+E8kuJnyShgUg7spPQKAAwxCr6M=";

  meta = with lib; {
    description = "Prometheus Cloudflare Exporter";
    mainProgram = "cloudflare-exporter";
    homepage = "https://github.com/lablabs/cloudflare-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.linux;
  };
}
