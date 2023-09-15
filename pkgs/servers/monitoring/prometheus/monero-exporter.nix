{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "monero-exporter";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "cirocosta";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MIWsWpLuUKITrce5bsJSau5ssLWkDcbWkCIIRYfveAA=";
  };

  vendorHash = "sha256-xhay4gu4LIijXlNdeHsWO7n/uHrodLNoGJBj/JH7rgs=";

  meta = with lib; {
    description = "Prometheus exporter for Monero nodes";
    homepage = "https://github.com/cirocosta/monero-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ mib ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "monero-exporter";
  };
}
