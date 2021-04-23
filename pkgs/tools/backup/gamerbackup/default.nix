{ lib, buildGoModule, fetchFromGitHub, lepton }:

buildGoModule {
  pname = "gb-backup";
  version = "unstable-2021-03-06";

  src = fetchFromGitHub {
    owner = "leijurv";
    repo = "gb";
    rev = "5a94e60148628fc7796d15c53d0ed87184322053";
    sha256 = "07skhwnxvm6yngb2665gkh5qbiyp7hb7av8dkckzypmd4k8z93cm";
  };

  vendorSha256 = "0m2aa6p04b4fs7zncar1mlykc94pp527phv71cdsbx58jgsm1jnx";

  buildInputs = [ lepton ];

  meta = with lib; {
    description = "Gamer Backup, a super opinionated cloud backup system";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ babbaj ];
    platforms = platforms.linux;
  };
}
