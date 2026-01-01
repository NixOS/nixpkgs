{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-piechart-panel";
  version = "1.6.4";
  zipHash = "sha256-bdAl3OmZgSNB+IxxlCb81abR+4dykKkRY3MpQUQyLks=";
<<<<<<< HEAD
  meta = {
    description = "Pie chart panel for Grafana";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Pie chart panel for Grafana";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
