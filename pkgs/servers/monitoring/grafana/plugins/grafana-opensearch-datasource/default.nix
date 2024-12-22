{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-opensearch-datasource";
  version = "2.19.0";
  zipHash = {
    x86_64-linux = "sha256-jTeiIbaM2wPBTxFyXPQhBXxxzgRZbaXkqeN9+tHgWPc=";
    aarch64-linux = "sha256-8ti5CibWbycAO9o3Wse/CuE07JjwV1Quhy/Vm6BDmyM=";
    x86_64-darwin = "sha256-6rqdTsYcqjqcXtM20ekJguT42w5dr4EUHvNuRDIU6k0=";
    aarch64-darwin = "sha256-Z4ISwwkFJXXdVcLOspAK8euI4yor4Ii08K7zZffY9tM=";
  };
  meta = with lib; {
    description = "The Grafana JSON Datasource plugin empowers you to seamlessly integrate JSON data into Grafana.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
