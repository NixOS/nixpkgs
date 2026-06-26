{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-googlesheets-datasource";
  version = "2.5.1";
  zipHash = {
    x86_64-linux = "sha256-Y6UvMLw+bAg0HTKsc2FdpY+S4Zf7gpgIVdZDFgr+mog=";
    aarch64-linux = "sha256-feBfv07DrKdeJbeD0gnYoOhg1LG636cghVu1x8n9rCQ=";
    x86_64-darwin = "sha256-nVbhhlfSkJwZ1PXzhYSz9pXxbcRyO32RoOPlV7OGAOk=";
    aarch64-darwin = "sha256-0iv1oUj6bLw7kUOwkW69rs+4NIetp+uEgJ7YULkKYLE=";
  };
  meta = {
    description = "Integrate JSON data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
