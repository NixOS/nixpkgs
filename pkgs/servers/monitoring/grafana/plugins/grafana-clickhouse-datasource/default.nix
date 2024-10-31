{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clickhouse-datasource";
  version = "4.4.0";
  zipHash = {
    x86_64-linux = "sha256-rh+oTJrW7WxLHG7jSkT1Pog+/tqhE+j/0jdbgaHu1a4=";
    aarch64-linux = "sha256-uV+WKh3/jBgOwX2lrwC3Q7TGr3/BH83QZhwmtL4G3qo=";
    x86_64-darwin = "sha256-Y6Xp4HCYF+Nkw8CNrfEMOtpNgKunMI/4oVqD8Wq5VEI=";
    aarch64-darwin = "sha256-x/Z5BA9N5sZurQ5K1NQCYXQPZ/yF1p/372GPIeVU0ps=";
  };
  meta = with lib; {
    description = "Connects Grafana to ClickHouse";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ moody ];
    platforms = attrNames zipHash;
  };
}
