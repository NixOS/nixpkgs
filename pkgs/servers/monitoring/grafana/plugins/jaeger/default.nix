{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "jaeger";
  version = "13.0.4";
  zipHash = "sha256-tn+/Ea/EMz1pPuV7PQJWXNE9KaR5VJc8NPCjT5iVw9o=";
  meta = {
    description = "Support for Jaeger traces";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
    platforms = lib.platforms.unix;
  };
}
