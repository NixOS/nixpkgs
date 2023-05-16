{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "SystemdJournal2Gelf";
<<<<<<< HEAD
  version = "unstable-2023-03-10";
=======
  version = "unstable-2022-02-15";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "parse-nl";
    repo = "SystemdJournal2Gelf";
<<<<<<< HEAD
    rev = "863a15df5ed2d50365bb9c27424e3b118ce404c0";
    hash = "sha256-AwJq0xZAoIpBz9kGERfmZZTn28LbAKIl3gUsFKL3yvs=";
  };

  vendorHash = null;
=======
    rev = "86f9f41b26b6848345c2424fbf1ff907b876bb5b";
    sha256 = "sha256-xsrKuZVN6Eb0vG98LbQnFqNxHthv+uL/h2HCDiFY0Oo=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" ];

  doCheck = false;

  meta = with lib; {
    description = "Export entries from systemd's journal and send them to a graylog server using gelf";
    homepage = "https://github.com/parse-nl/SystemdJournal2Gelf";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fadenb fpletz ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
