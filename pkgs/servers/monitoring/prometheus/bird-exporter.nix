{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "bird-exporter";
<<<<<<< HEAD
  version = "1.4.2";
=======
  version = "1.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "bird_exporter";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-XGHOEnAichQEir0k8wj/OSuj1zk8UsLYi9azg6lgpws=";
  };

  vendorHash = "sha256-X6zrCTGZaSdQS9bwzjbSGkmNs38JBxZMtrqajQxkzK0=";
=======
    sha256 = "sha256-QCnOMiAcvn0HcppGJlf3sdllApKcjHpucvk9xxD/MqE=";
  };

  vendorSha256 = "sha256-jBwaneVv1a8iIqnhDbQOnvaJdnXgO8P90Iv51IfGaM0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.tests = { inherit (nixosTests.prometheus-exporters) bird; };

  meta = with lib; {
    description = "Prometheus exporter for the bird routing daemon";
    homepage = "https://github.com/czerwonk/bird_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
  };
}
