{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-oncall-app";
  version = "1.3.106";
  zipHash = {
    x86_64-linux = "sha256-8TL8HqiYCUxY2tCItpavYb77rGIpcJBWexwykFNWONg=";
    aarch64-linux = "sha256-4rCj+NaKPZbuVohlKmSf1M6m5ng9HZMrwzBCgLPdiok=";
    x86_64-darwin = "sha256-bpey6EwwAqXgxjvjJ6ou4rimidHCpUr+Z89YpAZK7z8=";
    aarch64-darwin = "sha256-u/U2lu4szf9JFt/zfhGmWKF2OUqpJDNaSI69EDdi1+w=";
  };
  meta = with lib; {
    description =
      "Collect and analyze alerts, escalate based on schedules and deliver them to Slack, Phone Calls, SMS and others.";
    license = licenses.agpl3Only;
    maintainers = lib.teams.fslabs.members;
    platforms = attrNames zipHash;
  };
}
