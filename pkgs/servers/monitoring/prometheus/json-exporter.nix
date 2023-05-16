{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "prometheus-json-exporter";
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "json_exporter";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-5tFhk62ewRE87lxgVM2bytV9GbXT5iAwbJqklohYDvM=";
  };

  vendorHash = "sha256-Hij3lh92OCH+sTrzNl/KkjLAhPGffzzmxhPDO2wG0gA=";
=======
    sha256 = "sha256-33cu2DG6kgzCVQPaN9L8f/Iq76RqDPa+kE7qMt8czhI=";
  };

  vendorSha256 = "sha256-aMpJaxyBBfpsRJTxAO05926tQSt8qQoDDzLFbX4qwWc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.tests = { inherit (nixosTests.prometheus-exporters) json; };

  meta = with lib; {
    description = "A prometheus exporter which scrapes remote JSON by JSONPath";
    homepage = "https://github.com/prometheus-community/json_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz ];
    mainProgram = "json_exporter";
  };
}
