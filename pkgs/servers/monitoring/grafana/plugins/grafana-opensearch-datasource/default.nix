{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-opensearch-datasource";
  version = "2.24.0";
  zipHash = {
    x86_64-linux = "sha256-ZxlHl08pSqnVKZvVph5Bqjki7ukrV3UScJFRwW4y97o=";
    aarch64-linux = "sha256-ZwPq3Xz4Rcm2JiAZnZ0D/Z6SamlCnj0/PgXeT6rrxcQ=";
    x86_64-darwin = "sha256-HMifdRPl8RNb+m/eFaXATNRgDYLMG1UA6N/rWHMTR04=";
    aarch64-darwin = "sha256-MLVyOeVZ42zJjLpOnGSa5ogGNa7rlcA4qjASCVeA3eU=";
  };
  meta = with lib; {
    description = "Empowers you to seamlessly integrate JSON data into Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
