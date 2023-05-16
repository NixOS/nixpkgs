{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fastly-exporter";
<<<<<<< HEAD
  version = "7.6.1";
=======
  version = "7.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "peterbourgon";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-JUbjWAJ70iq0RCr6U2thbtZ3nmCic9wGtSf2ArRy4uA=";
  };

  vendorHash = "sha256-lEaMhJL/sKNOXx0W+QHMG4QUUE6Pc4AqulhgyCMQQNY=";
=======
    sha256 = "sha256-jZXQ5N6xIBk85ae4dPERB0tY5TBeIT6ThG6rLYLHmJ0=";
  };

  vendorSha256 = "sha256-BBfI5SyTgaoXXHxhraH09YVi43v1mD6Ia8oyh+TYqvA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Prometheus exporter for the Fastly Real-time Analytics API";
    homepage = "https://github.com/peterbourgon/fastly-exporter";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
