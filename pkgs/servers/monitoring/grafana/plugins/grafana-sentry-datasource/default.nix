{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-sentry-datasource";
  version = "2.2.1";
  zipHash = {
    x86_64-linux = "sha256-6pjBUqUHXLLgFzfal/OKsMBVlVXxuRglOj3XRnnduRY=";
    aarch64-linux = "sha256-0kjxBnv34lRB5qeVOyik7qvlEsz7CYur9EyIDTe+AKM=";
    x86_64-darwin = "sha256-yHgF+XmJXnJjfPwabs1dsrnWvssTmYpeZUXUl+gQxfM=";
    aarch64-darwin = "sha256-ysLXSKG7q/u70NynYqKKRlYIl5rkYy0AMoza3sQSPNM=";
  };
  meta = {
    description = "Integrate Sentry data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arianvp ];
    platforms = lib.platforms.unix;
  };
}
