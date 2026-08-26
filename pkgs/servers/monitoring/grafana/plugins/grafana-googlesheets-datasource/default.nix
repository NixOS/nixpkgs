{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-googlesheets-datasource";
  version = "2.6.1";
  zipHash = {
    x86_64-linux = "sha256-6Q/ZAwyUcpB491PyDIYz25clgMepzxGegTL1+i1oadY=";
    aarch64-linux = "sha256-/xpkAB51nJbX/8LWu8uN2elybuxysaNIHsLt0NErtbE=";
    aarch64-darwin = "sha256-EST0OcVMhQFYB5oRXmCUXVBLn34x9KcDceZrJFElVHY=";
  };
  meta = {
    description = "Integrate JSON data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
