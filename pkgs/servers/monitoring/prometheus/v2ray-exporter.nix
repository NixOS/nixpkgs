{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "v2ray-exporter";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "wi1dcard";
    repo = "v2ray-exporter";
    rev = "v${version}";
    sha256 = "12mzng3cw24fyyh8zjfi26gh853k5blzg3zbxcccnv5lryh2r0yi";
  };

  vendorHash = "sha256-+jrD+QatTrMaAdbxy5mpCm8lF37XDIy1GFyEiUibA2k=";

  meta = with lib; {
    description = "Prometheus exporter for V2Ray daemon";
    mainProgram = "v2ray-exporter";
    homepage = "https://github.com/wi1dcard/v2ray-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ jqqqqqqqqqq ];
  };
}
