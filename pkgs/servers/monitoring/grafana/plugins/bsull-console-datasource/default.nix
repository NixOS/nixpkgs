{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "bsull-console-datasource";
  version = "1.0.1";
  zipHash = "sha256-V6D/VIdwwQvG21nVMXD/xF86Uy8WRecL2RjyDTZr1wQ=";
<<<<<<< HEAD
  meta = {
    description = "Grafana data source which can connect to the Tokio console subscriber";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Grafana data source which can connect to the Tokio console subscriber";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
