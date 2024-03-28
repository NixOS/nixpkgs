{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-mqtt-datasource";
  version = "1.0.0-beta.3";
  zipHash = {
    x86_64-linux = "sha256-qkCnN6Xfgzo6pargynBOO4HvSp/7YTMnIJDeycMaiRw=";
    aarch64-linux = "sha256-Vsu7yQydekhqyDqpbW+rcFmEXEyJUfBINml6jR2HmaU=";
    x86_64-darwin = "sha256-o7Jx4H4H1gykjVYvS1htO9WJDlKUzUSMYjADr6v5jGM=";
    aarch64-darwin = "sha256-UfRAttBgmMpIGval1ACspj7QqRa26LJk7vD1WWM8Hmc=";
  };
  meta = with lib; {
    description = "The MQTT data source plugin allows you to visualize streaming MQTT data from within Grafana.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
