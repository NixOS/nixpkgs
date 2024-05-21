{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mqtt-benchmark";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "krylovsk";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-gejLDtJ1geO4eDBapHjXgpc+M2TRGKcv5YzybmIyQSs=";
  };

  vendorHash = "sha256-ZN5tNDIisbhMMOA2bVJnE96GPdZ54HXTneFQewwJmHI=";

  meta = with lib; {
    description = "MQTT broker benchmarking tool";
    homepage = "https://github.com/krylovsk/mqtt-benchmark";
    changelog = "https://github.com/krylovsk/mqtt-benchmark/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "mqtt-benchmark";
  };
}
