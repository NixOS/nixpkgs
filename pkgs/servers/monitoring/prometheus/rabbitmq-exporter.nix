{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rabbitmq_exporter";
<<<<<<< HEAD
  version = "1.0.0-RC19";
=======
  version = "1.0.0-RC8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kbudde";
    repo = "rabbitmq_exporter";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-31A0afmARdHxflR3n59DaqmLpTXws4OqROHfnc6cLKw=";
  };

  vendorHash = "sha256-ER0vK0xYUbQT3bqUosQMFT7HBycb3U8oI4Eak72myzs=";
=======
    sha256 = "162rjp1j56kcq0vdi0ch09ka101zslxp684x6jvw0jq0aix4zj3r";
  };

  vendorSha256 = "1cvdqf5pdwczhqz6xb6w86h7gdr0l8fc3lav88xq26r4x75cm6v0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Prometheus exporter for RabbitMQ";
    homepage = "https://github.com/kbudde/rabbitmq_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
