{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "prometheus-nats-exporter";
<<<<<<< HEAD
  version = "0.12.0";
=======
  version = "0.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-3LgxMbcq4vmFxFTrLrJECFqaD5xp9oJsFrqPXATkzqg=";
  };

  vendorHash = "sha256-2QGz+7CGBrQPukDMRDapQ5MMMqRTPS6kqsa9J6UXEXY=";
=======
    sha256 = "sha256-v8Afdz1X1s5P/soXB+9M4C01HbvPNlEXo7Hdf1o9NdM=";
  };

  vendorHash = "sha256-YpiwRkujjuqfNH1Mmv6mtm6nNXx6kp272+6fzsK97xw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preCheck = ''
    # Fix `insecure algorithm SHA1-RSA` problem
    export GODEBUG=x509sha1=1;
  '';

  meta = with lib; {
    description = "Exporter for NATS metrics";
    homepage = "https://github.com/nats-io/prometheus-nats-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ bbigras ];
  };
}
