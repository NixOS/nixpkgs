{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-googlesheets-datasource";
  version = "1.2.5";
  zipHash = {
    x86_64-linux = "sha256-KbKYAe8FQyn1Nme5HB4bXPdPZ36HBpskLeV8VP9jD18=";
    aarch64-linux = "sha256-pOOzkL3nBo0phGAHxDoWdHqvuyi6ZphzhPAUPa65z+g=";
    x86_64-darwin = "sha256-POKuxEuBqsxvL7/mHEtcWDKgNnwmA733/ZjoxEXdE5c=";
    aarch64-darwin = "sha256-BjH77wFqDFLvVYPWOENLB3kAmG/MvIRcTHNU/f+BwCI=";
  };
  meta = with lib; {
    description = "The Grafana JSON Datasource plugin empowers you to seamlessly integrate JSON data into Grafana.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
