{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "frser-sqlite-datasource";
  version = "3.4.0";
  zipHash = "sha256-4zRZmMIcIFHlLF6YFbg4LYv6KK2GkZJBOyKhXoZpHYQ=";
  meta = with lib; {
    description = "This is a Grafana backend plugin to allow using an SQLite database as a data source. The SQLite database needs to be accessible to the filesystem of the device where Grafana itself is running.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
