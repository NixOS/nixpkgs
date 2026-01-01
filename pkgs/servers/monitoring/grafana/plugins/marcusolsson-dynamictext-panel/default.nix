{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-dynamictext-panel";
  version = "6.2.0";
  zipHash = "sha256-pxTmylBvI73csDM6rMoUjGN9EM5zR/PfH1ZE1XKW94c=";
<<<<<<< HEAD
  meta = {
    description = "Dynamic, data-driven text panel for Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ herbetom ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Dynamic, data-driven text panel for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ herbetom ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
