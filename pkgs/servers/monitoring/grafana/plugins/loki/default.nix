{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "loki";
  version = "13.2.1";
  zipHash = "sha256-aoqSr/6xuMld7XzR15ljNNa3LZSM6oASZc1G7XWkcFg=";
  meta = {
    description = "Support for Loki data-source";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
    platforms = lib.platforms.unix;
  };
}
