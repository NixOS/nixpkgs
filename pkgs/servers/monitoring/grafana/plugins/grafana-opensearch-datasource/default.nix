{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-opensearch-datasource";
  version = "2.33.0";
  zipHash = {
    x86_64-linux = "sha256-oxPw/cQ/AYTHB4Z/hdt3Jqn3XXnx+bo3uAq6qS7hd6g=";
    aarch64-linux = "sha256-0bF2ebVF26iPIKs+oICeaBwm6K8TZGqTP6ONR+yDFvY=";
    x86_64-darwin = "sha256-yGJLaNCAmdIN1uuzh/v+adda6IRmcCH+mpbxno8qK9k=";
    aarch64-darwin = "sha256-Kxgq9HYXPW3+uEzJPy0kKDFCXrSFpCgZQ+whqx4XtJ8=";
  };
  meta = {
    description = "Empowers you to seamlessly integrate JSON data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
